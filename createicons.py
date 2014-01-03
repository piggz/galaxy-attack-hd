#!/usr/bin/env python

""" For all svg icons in parent dir, create .png versions at different sizes and installicons.pri

"""

import glob,os, sys

svgic = glob.glob("pgz-spaceinvaders.svg")

pri = ["# autogenerateb by createicons.py", "unix:!symbian {" ]



for ic in svgic:
    bn = os.path.basename(ic)
    name = os.path.splitext(bn)[0]
    
    sizes = [16, 32, 44, 48, 64, 80, 128]
    for sz in sizes:
        tgt = os.path.abspath("./data/%dx%d" % (sz, sz))
        if not os.path.isdir(tgt):
            os.makedirs(tgt)
            print "mkdir",tgt
        #cmd = "gm convert -depth 32 -background transparent -resize %dx%d %s %s/%s.png" % (
        #    sz, sz, ic, tgt, name
        #    
        #)
        cmd = "inkscape --export-png=%s/%s.png --export-width=%d --export-height=%d %s" % (
            tgt, name, sz, sz, ic   
        )
        
        
        pri.append("    icon%d.files = data/%dx%d/%s.png" % (sz, sz, sz, name))
        pri.append("    icon%d.path = /usr/share/icons/hicolor/%dx%d/apps" % (sz, sz, sz))
        pri.append("    INSTALLS += icon%d" % sz)
        
        print cmd
        os.system(cmd)

pri.append("}\n")
open ("./installicons.pri", "w").write("\n".join(pri))    
