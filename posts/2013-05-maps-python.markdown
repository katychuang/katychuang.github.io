---
date: 2013-05-25 00:00:00
title: Creating maps with Python
tags: pydata
---

There are several packages you can use to create maps. This post was inspired by this <a href="http://mrcactu5.herokuapp.com/blog/0524-topoJSON.html">d3 tutorial for drawing Puerto Rico</a> and this intro to <a href="http://danieljlewis.org/2010/09/15/drawing-maps-with-python/">Drawing maps with Python</a>. I tried pulling together some information for all of these packages; the documentation wasn't available on all the websites.
<table>
<tbody>
<tr>
<td><strong>Package</strong></td>
<td><strong>Formats</strong></td>
<td><strong>Requirements</strong></td>
<td><strong>Runs on GAE?</strong></td>
</tr>
<tr>
<td><a href="http://opentraveldata.github.io/geobases/">GeoBases</a>*Has search features, see below</td>
<td><strong>Input</strong>
Geo Coordinates
<strong>Output=</strong>
CSV, <span style="line-height:19px;">Python Object</span>
Social Graph, <span style="line-height:19px;">Maps</span></td>
<td>pyyaml
python_geohash
python_Levenshtein
fuzzy
argparse
termcolor
colorama</td>
<td>No. Export static files then upload</td>
</tr>
<tr>
<td><a href="https://github.com/stamen/modestmaps-py">ModestMaps</a></td>
<td>?</td>
<td></td>
<td></td>
</tr>
<tr>
<td><a href="http://kartograph.org/">Kartograph</a> (<a href="http://kartograph.org/docs/kartograph.py/">Docs</a>)</td>
<td>?<strong>Output=</strong>
SVG</td>
<td>GDAL/OGR
shapely</td>
<td></td>
</tr>
<tr>
<td><a href="https://github.com/wrobstory/vincent">Vincent</a> (<a style="line-height:19px;" href="http://wrobstory.github.io/2013/04/python-maps-chloropleth.html">Tutorial</a>)</td>
<td>Inputs JSON</td>
<td> <a href="http://trifacta.github.io/vega/">Vega</a></td>
<td></td>
</tr>
<tr>
<td><a href="http://pythonhosted.org/PySAL/">PySal </a><span style="line-height:19px;">(</span><a style="line-height:19px;" href="http://pythonhosted.org/PySAL/users/tutorials/index.html#users-tutorials">Docs</a><span style="line-height:19px;">)</span></td>
<td><strong>Input/Output= </strong>
SHP shapefile
DBF
CSV
WKT
GeoDa
GAL
GWT
ArcGIS
MTX
DAT
MAT matlab
STATA</td>
<td></td>
<td></td>
</tr>
</tbody>
</table>
<strong><em>Notes:</em></strong>

GeoBase also offers search features, in case you wanted to create an app for geo information.
<ul>
    <li>perform various types of queries (find <em>this key</em>, or find keys with <em>this property</em>)</li>
    <li>make <em>fuzzy searches</em> based on string distance (find things <em>roughly named like this</em>)</li>
    <li>make <em>phonetic searches</em> (find things <em>sounding like this</em>)</li>
    <li>make <em>geographical searches</em> (find things <em>next to this place</em>)</li>
</ul>
