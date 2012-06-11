#!/usr/bin/env python
# encoding: utf-8
"""
issue-watcher.py
Find changeset links in issues stored in the W3C bugzilla

Created by Olivier Thereaux on 2012-05-25.
Copyright (c) 2012. All rights reserved.
"""

import sys
import os
import re
import urllib2
import urllib
import html5lib
from html5lib import treebuilders
from xml.etree import cElementTree

def getSettings():
    """set the config variables here"""
    conf = {
        "mailing-list": 'public-audio',
        "bugzilla": 'https://www.w3.org/Bugs/Public/',
        "bugzilla-product": 'AudioWG',
        "dvcs": 'https://dvcs.w3.org/hg/audio/rev'
    }
    return conf

def getIssuesList(settings):
    issues = list()
    namespace = 'http://www.w3.org/1999/xhtml'
    bugzilla_query = settings['bugzilla']+'buglist.cgi?product='+settings['bugzilla-product']+'&longdesc_type=allwordssubstr&bug_status=RESOLVED&longdesc='+urllib.quote(settings['dvcs'])+'&order=Last+Changed'
    parser = html5lib.HTMLParser(tree=treebuilders.getTreeBuilder("etree", cElementTree))
    etree_document = parser.parse(urllib2.urlopen(bugzilla_query).read())
    for bugtd in etree_document.findall(".//{%s}td[@class='first-child bz_id_column']" % namespace ):
        for link in bugtd.findall(".//{%s}a" % namespace):
            issues.append(link.text)
    return issues
    
    
def findChangeset(issue_id, settings):
    print
    namespace = 'http://www.w3.org/1999/xhtml'
    parser = html5lib.HTMLParser(tree=treebuilders.getTreeBuilder("etree", cElementTree))
    etree_document = parser.parse(urllib2.urlopen(settings["bugzilla"]+"show_bug.cgi?id="+str(issue_id)).read())
    for title in etree_document.findall(".//{%s}title" % namespace):
        print title.text
    changesets = list()
    for div in etree_document.findall(".//{%s}pre[@class='bz_comment_text']" % namespace ):
        for link in div.findall(".//{%s}a" % namespace ):
            if re.search(settings['dvcs'], link.attrib['href']):
                if link.attrib['href'] not in changesets:
                    changesets.append(link.attrib['href'])              
    if len(changesets) > 1:
        print "Changesets: ", ", ".join(changesets)
    else:    
        print "Changeset: ", changesets[0]
    print "Last Modified: ", re.search(r"Last modified: (.*) UTC", cElementTree.tostring(etree_document)).group(1)
    
                

def main():
    settings = getSettings()
    pendingreview = getIssuesList(settings)
    for issue_id in pendingreview:
        findChangeset(issue_id, settings)

if __name__ == '__main__':
	main()

