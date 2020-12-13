#!/usr/bin/env python3
import csv
import sys
import xml.etree.ElementTree as ET

### Natural key sorting for orders like : C1, C5, C10, C12 ... (instead of C1, C10, C12, C5...)
# http://stackoverflow.com/a/5967539
import re

def atoi(text):
    return int(text) if text.isdigit() else text

def natural_keys(text):
    '''
    alist.sort(key=natural_keys) sorts in human order
    http://nedbatchelder.com/blog/200712/human_sorting.html
    (See Toothy's implementation in the comments)
    '''
    return [ atoi(c) for c in re.split('(\d+)', text) ]
###

def parse_kicad_xml(input_file):
    """Parse the KiCad XML file and look for the part designators
    as done in the case of the official KiCad Open Parts Library:
    * OPL parts are designated with "SKU" (preferred)
    * other parts are designated with "MPN"
    """
    components = {}
    parts = {}
    missing = []

    tree = ET.parse(input_file)
    root = tree.getroot()
    for f in root.findall('./components/'):
        name = f.attrib['ref']
        info = {}
        fields = f.find('fields')
        opl, mpn = None, None
        if fields is not None:
            for x in fields:
                if x.attrib['name'].upper() == 'SKU':
                    opl = x.text
                elif x.attrib['name'].upper() == 'MPN':
                    mpn = x.text
        if opl:
            components[name] = opl
        elif mpn:
            components[name] = mpn
        else:
            missing += [name]
            continue
        if components[name] not in parts:
            parts[components[name]] = []
        parts[components[name]] += [name]
    return components, missing

def write_bom_seeed(output_file_slug, components):
    """Write the BOM according to the Seeed Studio Fusion PCBA template available at:
    https://statics3.seeedstudio.com/assets/file/fusion/bom_template_2016-08-18.csv

    ```
    Part/Designator,Manufacture Part Number/Seeed SKU,Quantity
    C1,RHA,1
    "D1,D2",CC0603KRX7R9BB102,2
    ```

    The output is a CSV file at the `output_file_slug`.csv location.
    """
    parts = {}
    for c in components:
        if components[c] not in parts:
            parts[components[c]] = []
        parts[components[c]] += [c]

    field_names = ['Part/Designator', 'Manufacture Part Number/Seeed SKU', 'Quantity']
    with open("{}.csv".format(output_file_slug), 'w') as csvfile:
        bomwriter = csv.DictWriter(csvfile, fieldnames=field_names, delimiter=',',
                    quotechar='"', quoting=csv.QUOTE_MINIMAL)
        bomwriter.writeheader()
        for p in sorted(parts.keys()):
            pieces = sorted(parts[p], key=natural_keys)
            designators = ",".join(pieces)
            bomwriter.writerow({'Part/Designator': designators,
                                'Manufacture Part Number/Seeed SKU': p,
                                'Quantity': len(pieces)})


if __name__ == "__main__":
    input_file = sys.argv[1]
    output_file = sys.argv[2]

    components, missing = parse_kicad_xml(input_file)
    write_bom_seeed(output_file, components)
    if len(missing) > 0:
        print("** Warning **: there were parts with missing SKU/MFP")
        print(missing)
