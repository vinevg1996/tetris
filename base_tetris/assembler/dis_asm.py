#!/usr/bin/python

# load = 0, down = 1, left = 2, right = 3
# T = 0, Q = 1, I = 2, Z = 3, S = 4, J = 5, L = 6

import sys
in_f = open("test_tetris.asm", 'r')
out_f = open('../mem_content.list', 'w')

for line in in_f:
    words = line.split(" ");
    if words[0] == "load":
        out_f.write("00000000")
    elif words[0] == "down":
        out_f.write("00000001")
    elif words[0] == "left":
        out_f.write("00000010")
    elif words[0] == "right":
        out_f.write("00000011")
    elif words[0] == "rotR":
        out_f.write("00000100")
    elif words[0] == "rotL":
        out_f.write("00000101")
    if ("T" in words[1]):
        out_f.write("00000000")
    elif ("Q" in words[1]):
        out_f.write("00000001")
    elif ("I" in words[1]):
        out_f.write("00000010")
    elif words[1] == "Z":
        out_f.write("00000011")
    elif words[1] == "S":
        out_f.write("00000100")
    elif words[1] == "J":
        out_f.write("00000101")
    elif words[1] == "L":
        out_f.write("00000110")
    out_f.write("\n")
