#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Author: jsgounot
# @Date:   2022-06-28 17:38:49
# @Last Modified by:   jsgounot
# @Last Modified time: 2022-09-30 20:08:43

import argparse
import pysam
import sys

parser = argparse.ArgumentParser()
parser.add_argument("--min_coverage", dest="min_coverage", default=0.7, type=float, help="a minimum read coverage [0,1] (default: 0.8)", required=False)
parser.add_argument("--min_identity", dest="min_identity", default=0.7, type=float, help="a minimum alignement identity [0,1] (default: 0.9)", required=False)
parser.add_argument("--input", dest="input", default="-", type=str, help="input file (default: stdin)", required=False)
parser.add_argument("--output", dest="output", default="-", type=str, help="output file (default: stdout)", required=False)

args = parser.parse_args()

bamfile = pysam.AlignmentFile(args.input, "rb")
outfile = pysam.AlignmentFile(args.output, "wb", template=bamfile)

fixes = 0
identity_threshold = 1 - args.min_identity

for idx, read in enumerate(bamfile.fetch(until_eof=True)):
    correctly_mapped = False

    if read.infer_query_length() != None and read.is_proper_pair:
        len_ops, num_ops = read.get_cigar_stats()

        # (M + I + D / read_length) and NM / (M + I + D)
        mid = sum(len_ops[0:3])

        if (mid / read.infer_read_length() >= args.min_coverage) and (len_ops[10] / mid <= identity_threshold):
            correctly_mapped = True

    if not correctly_mapped:
        read.is_mapped = False
        read.is_proper_pair = False
        read.is_unmapped = True

        # This one is tricky but I need it for flag 12
        read.mate_is_unmapped = True
        fixes += 1

    outfile.write(read)

bamfile.close()
outfile.close()

sys.stderr.write('filter done with %i corrections out of %i reads\n' %(fixes, idx))
