---
title: System Setup Overview
date: "2021-07-04 09:00:00 +0530"
categories:
  - System Setup Overview
tags:
  - setup, tools, prerequisite
toc: true
---


## Purpose

Assembling and setting up decent system for Multi purpose:

* Computer Vision and Image Processing
* Machine Learning
* Deep Learning
* 3D GIS - Photogrammetry, Point Cloud, LiDAR, 3D Modelling
* Data Analysis, Data Visualization
* VR,AR
* Computer Graphics, VFX
* **Key Topics**:
  * Computer Vision and Image Processing
  * Machine Learning
  * Deep Learning
  * 3D GIS - Photogrammetry, Point Cloud, LiDAR, 3D Modelling
  * Data Analysis, Data Visualization
* **Key Programming Langaugaes:**
  * python, bash shell scripting, nodejs
  * js, php, css, html5
  * c++
* **Key Tools:**
  * OpenCV, PCL
  * CloudCompare, MeshLab, Blender
  * Keras, TensorFlow
  * OpenSfM, OpenDroneMap
  * PostgreSQL, QGIS
  * Apache
  * Elastic Search
  * R, ROS, Octave


## Summary on Software Stack Setup
> Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS

### Key Learnings & Takeaway

* [photogrammetry, computer vision, gis] and [deeplearning] should happen in separate docker containers and virtualenv setups
* VTK is the key software package to support 3D
* Most of the softwares like pcl, vtk, opencv allows Andoid builds, hence Android SDK, NDK should be installed in early stages itself
* android studio is the convenient way to install Android SDK and NDK
* latest android sdk will not be supported with vtk, opencv; so stick with v24 or check with the desired package
* upgrade CMAKE and CCMAKE early. cmake 3.7+ is required to build android with vtk. default with Ubuntu 16.04 LTS is 3.5+
* keep the data and software packages separate
* Install under `/usr/local/lib`. It saves lot of pain to export the path to individual build directories and system default libs will safely sit under `/usr/lib`.
* DO NOT uninstall system default components especially certain dependencies like imagemagic, cmake, openssl etc. This will have cascading effect and will possibly leave your entire system broken in some places which will bite you at unexpected time
* set the exports properly, maily SDK home paths (java, android sdk & ndk)
* Enabling userdir module for apache allows to have each user to host individual apache root directory. I prefer this setup instead of running as sudo or chown alternatives
* this setup was more inclined towards single user, single system setup and for server or server like setup will have a little variation as one would like all users to be able to use the same software stack possibly installed by a sysadmin user.
* server or server like setup will have common group and multiple users
* In the network and resource sharing, 3 level git setup may be attractive for development purpose where individual users will pull from the local server and the serve would clone from github resources. This way every individual would have sort of consistent software stack/components that avoids unnecessary software issues
* every system build is unqiue and is suspectible to the **[butterfly effect](https://en.wikipedia.org/wiki/Butterfly_effect)** `;)`
* Installing ROS on the deep learning system will possibly mess it up according to an experience shared over internet

### Jul 2018

* Ubuntu 18.04 LTS released in Apr-2018, preferred if setting up from scratch
* Support and other build seems to be working good so far with minor enhancements in the scripts
* tensorRT released with CUDA 9.1 support
* Ubuntu 18.04 LTS
  * cmake 3.10.2: manual build upgrade not required in most of the cases
* Ubuntu 16.04 LTS
  * cmake 3.5: manual build upgrade required

### May 2018

* Ubuntu 16.04 LTS is a better option to stick with instead of using Ubuntu 17+
* Latest hardware has additional cost of compiling every other major opensource software from source
* CUDA 9.0 vs CUDA 9.1
  * Deep Learning frameworks have CUDA 9.0 widely supported compared to CUDA 9.1
  * Installing CUDA 9.1 compelled to compile tensorflow, as CUDA 9.1 was not supported in bin installation
  * tensorRT was only avaiable with CUDA 9.0 support, It's propriatory hence at mercy of Nvidia to release CUDA 9.1 supported version.
  * If tensorRT is required check CUDA version support before installing CUDA
  * DriveWork from Nvidia requires tensorRT, hence install CUDA 9.0
* boost 1.64.0 instead of 1.67.0 is safer version to install
* Computer Graphics (like gimp, inkscape, krita etc), VFX (natron, blender, fusion) software stack are self contained and easier to install anywhere at least on Ubuntu 16.04 LTS
* 3D GIS takes the leap with qGIS-3 release, but its little hard to install/build on Ubuntu 16.04 LTS

### What Could have been a better Setup

* virtualenv setups for different toolchains with python2 and python3 running in separate virtual env
* docker container setups for intrusive software pipeline i.e. that has multiple dependencies, different version compatibility issues like OpenDroneMap

### Word of CAUTION

* **Be careful** on installing and uninstalling openssl1.1.0. There are breaking changes in 1.1.1 verison compared to openssl1.0.0 
* **Be careful** on running `sudo apt autoremove` and always check what gets uninstalled.
* **The install scripts are crafted to take care repeatable job, they are not perfect, always open and read it before executing them**


## Ubuntu 18.04 LTS - Sequence of Software Installed
> Tested on Ubuntu 18.04 LTS

* Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
* **Configuration:**
  - Assumes softwares are downloaded at path: `$HOME/Downloads`
  - Assumes softwares are extracted and installed at path: `$HOME/softwares`
* **Software Version:**
  - defines the softwate's `versions/builds/release` to download
* **Naming Convention:**
  - If downloaded as tar/bz/bz2 files, same name is used to extract and build it from sources
  - Git cloned does not have version name appended to the folder so far, and assume to use the latest sources.
    - This may be an issue for people who needs specific version/build/release. - [TBD]
* **Without GPU**
  - Skip gpu specific installation steps/scripts: Nvidia, CUDA, TensorRT
  - When building from source GPU support should be disabled in pcl, vtk and other library
* **TBD:**
  - For git clone include `checkout` option to build from the stable release (case-by-case basis)
  - Check for versionfor `Ubuntu 16.04 / 18.04` and create the checks in the scripts to install respective dependencies


**Individual Scripts & Sequence of Installation**
* [Nvidia Driver -> 390.1] - Manual Driver Installation Preferred
* [vim-gtk]
* [SublimeText 3 editor]
* [utils]
* [java -> JDK:1.8]
* [python -> 2.7+]
* [php, composer and php extensions]
* [apache2 -> this installed latest PHP version (currently, version=7.2)]
* [nodejs -> nodejs=9.11.1, npm=5.6.0]
* [VLC]
* [ffmpeg]
* [Inkscape - graphics]
* [gimp - graphics]
* [MySQL]
* [postgres]
* [Cuda -> 9.1]
* [cuDNN -> 7.1.2]
* [Ceres Solver -> 1.14.0]
* [proj -> VER="4.9.3"]
* [tiff -> VER="4.0.8"]
* [geotiff -> VER="1.4.2"]
* [lasZip -> git clone]
* [geoos -> VER="3.6.1"]
* [pre-requisites: opencv, pcl, lzma, jsoncpp, libarchive, libhash, MPI - mpich or openmpi and others: for computer vision and deep learning]
* [Boost, Boost Python (it is boost  compiled with python) -> 1.64.0]
* [laz-perf]
* [geowave] - **not installed**
* [libkml]
* install android SDK - **manual**
* install android NDK - **manual**
* install android studio - **manual**
* [gdal -> VER="2.2.4"]
* [libLAS -> git clone] - **# on building from source, provide the path to laszip, proj4, tiff source directory**
* [openscenegraph] - **I guess it should be here, instead at later stage**
* [Rasdaman] - **not installed**
* [grassgis]
* [libght]
* [hexer]
* [pgpointcloud]
* [openscenegraph]
* [pdal] - **with compressin and laz-perf**
* [entwine] - **manual fix openssl1.1 api changes**
* [simple-web-server]
* [greyhound] - **FAILED, incompatibple with latest entwine; works only with 1.x release**
* [VTK -> VER="8.1.0"] - **(python wrapper and group images, group web)**
* [pcl]
* [cmake, ccmake upgrade to 3.11.0] - **skipped in Ubuntu 18.04 LTS**
* [qGIS-3] - **through apt-get, build way not yet working**
* [opencv]
* QT -> 5.10+ [skipped, be careful if unsuccessul can leave the system in broken state]
* [CloudCompare]
* [OpenGv] - **required by OpenSfM**
* [OpenSfM]
* [vcglib] - **required by MeshLab**
* [meshlab] - **not installed, compilation errors**
* [OpenDroneMap] - **not installed, compilation errors**
* [Tensorflow] - ** Manual Install - look into script for reference only - many params: CPU/GPU, python version, release**

## Ubuntu 16.04 LTS - Sequence of Software Installed
> Tested on Ubuntu 16.04 LTS

* [Nvidia Driver -> 390.1] - Manual Driver Installation Preferred
* [vim-gtk]
* [SublimeText 3 editor]
* [VLC]
* [utils]
* [php, composer and php extensions]
* [apache2 -> this installed latest PHP version (currently, version=7.2)]
* [nodejs -> nodejs=9.11.1, npm=5.6.0]
* opencv pre-requisites for computer vision and deep learning
* [java -> JDK:1.8]
* [python -> 2.7+]
* [postgres]
* [Cuda -> 9.1]
* [cuDNN -> 7.1.2]
* [Inkscape - graphics]
* [gimp - graphics]
* [Ceres Solver -> 1.14.0]
* [proj -> VER="4.9.3"]
* [tiff -> VER="4.0.8"]
* [geotiff -> VER="1.4.2"]
* [lasZip -> git clone]
* [geoos -> VER="3.6.1"]
* [Boost, Boost Python (it is boost  compiled with python) -> 1.64.0]
* libkml -> compilation errors
* [cmake, ccmake upgrade to 3.11.0]
* install android SDK - manual
* install android NDK - manual
* install android studio - manual
* [gdal -> VER="2.2.4"]
* [libLAS -> git clone] - # on building from source, provide the path to laszip, proj4, tiff source directory
* [MySQL]
* lzma, jsoncpp, libarchive, libhash
* [VTK -> 8.1.0 (python wrapper and group images, group web)]
* [lasperf]
* [grassgis]
* [pgpointcloud]
* geowave - not installed
* [pdal with compressin and las-perf, python fails, without python installed]
* [entwine - manual fix openssl1.1 api changes]
* greyhound -failed
* [pcl]
* [opencv]
* openscenegraph - not installed
* hexbin - not installed
* QT -> 5.10+ [skipped, be careful if unsuccessul can mess up your system]
* CloudCompare - not installed
* meshlab - not installed
* MPI - mpich or openmpi - should be installed in the beginning, so that programs can be compiled to take advantage of multiple processors

**Setup on Ubuntu 16.04 LTS**

| Directory-name       | Status           | Version/Release | Download Type       | Remarks                                                                       | 
|----------------------|------------------|-----------------|---------------------|-------------------------------------------------------------------------------| 
| ├── android          | Installed        | latest          | Download            | SDK,NDK                                                                       | 
| ├── android-studio   | Installed        | latest          | Download            |                                                                               | 
| ├── boost_1_64_0     | Installed        | 1.64.0          | Download – wget     |                                                                               | 
| ├── caffe            | Not-compiled     | latest          | git clone           |                                                                               | 
| ├── ceres-solver     | Installed        | 1.14.0          | git clone           |                                                                               | 
| ├── cloudcompare     | Not-compiled     | latest          | git clone           |                                                                               | 
| ├── cmake-3.11.0     | Installed        | 3.11.0          | Download – wget     | Min 3.7+ is required for certain features – like for android support from pcl | 
| ├── cudnn_samples_v7 | Installed        | 1.7.1           | Registered Download | cuDNN samples for testing                                                     | 
| ├── eigen            | Installed        | latest          | git clone           |                                                                               | 
| ├── entwine          | Installed        | latest          | git clone           |                                                                               | 
| ├── gdal-2.2.4       | Installed        | 2.2.4           | Download – wget     |                                                                               | 
| ├── geos-3.6.1       | Installed        | 3.6.1           | Download – wget     |                                                                               | 
| ├── LASzip           | Installed        | latest          | git clone           |                                                                               | 
| ├── laz-perf         | Installed        | latest          | git clone           |                                                                               | 
| ├── libgeotiff-1.4.2 | Installed        | 1.4.2           | Download – wget     |                                                                               | 
| ├── libkml-1.2.0     | Failed           | 1.2.0           | 1.3.0               |                                                                               | 
| ├── opencv           | Installed        | latest          | git clone           |                                                                               | 
| ├── opencv_contrib   | Installed        | latest          | git clone           | certain contrib are disabled – sfm                                            | 
| ├── OpenDroneMap     | Failed           | latest          | git clone           |                                                                               | 
| ├── opengv           | Installed        | latest          | git clone           |                                                                               | 
| ├── OpenSfM          | Installed-Broken | latest          | git clone           | core dump on reconstruction step. Consider not working                        | 
| ├── pcl              | Installed        | latest          | git clone           |                                                                               | 
| ├── PDAL-1.7.1-src   | Installed        | 1.7.1           | Download – wget     |                                                                               | 
| ├── pointcloud       | Installed        | latest          | git clone           |                                                                               | 
| ├── proj-4.9.3       | Installed        | 4.9.3           | Download – wget     |                                                                               | 
| ├── protobuf         | Installed        | latest          | git clone           |                                                                               | 
| ├── tensorflow       | Installed        | latest          | git clone           | 1.8.0:python3:CUDA 9.1:CuDNN 7.1.2: 1.7.0:python2:CUDA 9.1:CuDNN 7.1.2        | 
| ├── tiff-4.0.8       | Installed        | 4.0.8           | Download – wget     | used by geotiff                                                               | 
| └── VTK-8.1.0        | Installed        | 8.1.0           | Download – wget     | freely available software system for 3D computer graphics                     | 


## Other Package/libs details

* **[PDAL - Point Data Abstraction Library](https://pdal.io/)**
* **[CGAL - Computational Geometry Algorithms Library](https://www.cgal.org/)**
  * The Computational Geometry Algorithms Library (CGAL) is a C++ library that aims to provide easy access to efficient and reliable algorithms in computational geometry.
    ```bash
    sudo apt-get install libcgal-dev # install the CGAL library
    sudo apt-get install libcgal-demo # install the CGAL demos
    #
    #sudo apt-get install libxerces-c-dev
    #sudo apt install libjsoncpp-dev
    #
    #sudo apt-get install libqt5x11extras5-dev
    #sudo apt-get install qttools5-dev
    #
    #sudo apt install libsuitesparseconfig4.4.6 libsuitesparse-dev
    #sudo apt install metis libmetis-dev
    #
    ```
* **[GDAL - Geospatial Data Abstraction Library](http://www.gdal.org/)**
  - It is a translator library for raster and vector geospatial data formats that is released under an X/MIT style Open Source license by the Open Source Geospatial Foundation.
* **mrf**
  - mrf: monochrome recursive format (compressed bitmaps). This program is part of Netpbm(1) MRF is a compressed format for bilevel (1-bit mono) images.
* **cryptopp**
  - Crypto++ Library is a free C++ class library of cryptographic schemes.
* **Armadillo**
  - A high quality linear algebra library (matrix maths) for the C++ language, aiming towards a good balance between speed and ease of use
* **[rasdaman](http://www.rasdaman.org/)**
  - Rasdaman is an Array DBMS, that is: a Database Management System which adds capabilities for storage and retrieval of massive multi-dimensional arrays, such as sensor, image, and statistics data.
* **[sfcgal](https://oslandia.github.io/SFCGAL/installation.html)**
  - SFCGAL is a C++ wrapper library around CGAL with the aim of supporting ISO 191007:2013 and OGC Simple Features for 3D operations.
* **pcre**
  - Perl Compatible Regular Expressions is a library written in C, which implements a regular expression engine, inspired by the capabilities of the Perl programming language.
* **[qhull](http://www.qhull.org/)**
  - Qhull computes the convex hull, Delaunay triangulation, Voronoi diagram, halfspace intersection about a point, furthest-site Delaunay triangulation, and furthest-site Voronoi diagram
* **geoos**
  - GEOS stands for Geometry Engine Open Source
* **[IDB](http://www.gdal.org/drv_idb.html)**
  - IBM Informix Database (driver support)
* **Teigha**
  - DWG Support
  - http://www.gdal.org/ogr_feature_style.html
  - http://www.gdal.org/drv_dwg.html
* **WebP**
  - WebP is a modern image format that provides superior lossless and lossy compression for images on the web. ... WebP lossy images are 25-34% smaller than comparable JPEG images at equivalent SSIM quality index. Lossless WebP supports transparency (also known as alpha channel) at a cost of just 22% additional bytes.
  - http://www.gdal.org/frmt_webp.html
* **Epsilon**
  - The Epsilon library can be used for using wavelets in GDAL.
* **FreeXL**
  - An open source library to extract valid data from within an Excel (.xls) spreadsheet. 
* **OpenCL**
  - OpenCL™ (Open Computing Language) is the open, royalty-free standard for cross-platform, parallel programming of diverse processors found in personal computers, servers, mobile devices and embedded platforms.
* **Poppler**
  - a PDF rendering library based on the xpdf-3.0 code base
* **Podofo**
  - a library to work with the PDF file format and includes also a few tools. The name comes from the first two letters of each word in PDF's spelled-out form.
* **PDFium**
  - an open-source PDF rendering
* **[SWIG](http://www.swig.org/)**
  - [SWIG](https://github.com/swig/swig/wiki/Getting-Started) is a software development tool that connects programs written in C and C++ with a variety of high-level programming languages. SWIG is used with different types of target languages including common scripting languages such as Javascript, Perl, PHP, Python, Tcl and Ruby. 
  - `swig -version`
  - Build [PHP extensions with SWIG](https://www.ibm.com/developerworks/library/os-php-swig/index.html)
* **MPI**
  - MPI is a parallel computing standard that allows programs to take advantage of multiple processors. There are two competing MPI implementations available on most Linux distributions: mpich and openmpi. 
    ```bash
    sudo apt-get install libmpich-dev
    ```
* **[CUnit]( https://mysnippets443.wordpress.com/2015/03/07/ubuntu-install-cunit/) - Automation test suite for C**
  ```bash
  sudo apt install libcunit1 libcunit1-dev
  #sudo apt-get install libcunit1 libcunit1-doc libcunit1-dev
  ```
* **[OpenSceneGraph - OSG](http://www.openscenegraph.org/)**
  - The OpenSceneGraph is an open source high performance 3D graphics toolkit, used by application developers in fields such as visual simulation, games, virtual reality, scientific visualization and modelling.
  - Written entirely in Standard C++ and OpenGL
* **[Hexer](https://github.com/hobu/hexer)**
  - Hexer is a library with a simple CMake-based build system that provides simple hexagon gridding of large point sets for density surface generation and boundary approximation.
  - It is used by filters.hexbin (pdal) to output density surfaces and boundary approximations.
  - Uses `Cario` for `with_drawing` option - Choose to build Cairo-based SVG drawing
* **[Cario](https://cairographics.org/)**
  - Cairo is a 2D graphics library with support for multiple output devices. Currently supported output targets include the X Window System (via both Xlib and XCB), Quartz, Win32, image buffers, PostScript, PDF, and SVG file output.
  - [cairo-1.14.12](https://cairographics.org/news/cairo-1.14.12/)
* **[Entwine](https://github.com/connormanning/entwine)**
  - Entwine is a data organization library for massive point clouds, designed to conquer datasets of hundreds of billions of points as well as desktop-scale point clouds. Entwine can index anything that is PDAL-readable, and can read/write to a variety of sources like S3 or Dropbox. Builds are completely lossless, so no points will be discarded even for terabyte-scale datasets.
* **[Greyhound](https://github.com/hobu/greyhound)**
  - A point cloud streaming framework for dynamic web services and native applications.
  - Prior to installing natively, you must first install PDAL and its dependencies, and then install Entwine.
* **[OpenCV](https://opencv.org/)**
  - OpenCV (Open Source Computer Vision Library) is released under a BSD license and hence it’s free for both academic and commercial use. It has C++, Python and Java interfaces and supports Windows, Linux, Mac OS, iOS and Android. OpenCV was designed for computational efficiency and with a strong focus on real-time applications. Written in optimized C/C++, the library can take advantage of multi-core processing. Enabled with OpenCL, it can take advantage of the hardware acceleration of the underlying heterogeneous compute platform.
* **[GStreamer GL libraries](https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-plugins-base-libs/html/gl.html)**
  - [bionic: libgstreamer-gl1.0-0](https://launchpad.net/ubuntu/bionic/+package/libgstreamer-gl1.0-0)
  - GStreamer is a streaming media framework, based on graphs of filters
 which operate on media data. Applications using this library can do
 anything from real-time sound processing to playing videos, and just
 about anything else media-related. Its plugin-based architecture means
 that new data types or processing capabilities can be added simply by
 installing new plug-ins.
    ```bash
    apt-cache search libgstreamer*
    #
    libgstreamer-gl1.0-0 - GStreamer GL libraries
    libgstreamer-plugins-base1.0-0 - GStreamer libraries from the "base" set
    libgstreamer-plugins-base1.0-dev - GStreamer development files for libraries from the "base" set
    libgstreamer-plugins-good1.0-0 - GStreamer development files for libraries from the "good" set
    libgstreamer-plugins-good1.0-dev - GStreamer development files for libraries from the "good" set
    libgstreamer1.0-0 - Core GStreamer libraries and elements
    libgstreamer1.0-0-dbg - Core GStreamer libraries and elements
    libgstreamer1.0-dev - GStreamer core development files
    libgstreamer-ocaml - OCaml interface to the gstreamer library -- runtime files
    libgstreamer-ocaml-dev - OCaml interface to the gstreamer library -- development files
    libgstreamer-opencv1.0-0 - GStreamer OpenCV libraries
    libgstreamer-plugins-bad1.0-0 - GStreamer libraries from the "bad" set
    libgstreamer-plugins-bad1.0-dev - GStreamer development files for libraries from the "bad" set
    libgstreamer1-perl - Bindings for GStreamer 1.0, the open source multimedia framework
    libgstreamerd-3-0 - GStreamer media framework - D bindings
    libgstreamerd-3-dev - GStreamer media framework - development files for D
    libgstreamermm-1.0-1 - C++ wrapper library for GStreamer (shared libraries)
    libgstreamermm-1.0-dev - C++ wrapper library for GStreamer (development files)
    libgstreamermm-1.0-doc - C++ wrapper library for GStreamer (documentation)
    ```
* **[Ccache](https://en.wikipedia.org/wiki/Ccache)**
  - ccache is a software development tool that caches the output of C/C++ compilation so that the next time, the same compilation can be avoided and the results can be taken from the cache. This can greatly speed up recompiling time. The detection is done by hashing different kinds of information that should be unique for the compilation and then using the hash sum to identify the cached output.
* **[CloudCompare](http://www.danielgm.net/cc/)**
  - CloudCompare [github]](https://github.com/CloudCompare/CloudCompare) is a 3D point cloud (and triangular mesh) processing software. It was originally designed to perform comparison between two 3D points clouds (such as the ones obtained with a laser scanner) or between a point cloud and a triangular mesh. It relies on an octree structure that is highly optimized for this particular use-case. It was also meant to deal with huge point clouds (typically more than 10 millions points, and up to 120 millions with 2 Gb of memory).
* **git**
  - `git --version`
  - In Ubuntu 18.04 LTS: `git version 2.17.1`
* **[OpenGV](http://laurentkneip.github.io/opengv), [github](https://github.com/laurentkneip/opengv)**
  - OpenGV is a collection of computer vision methods for solving geometric vision problems. It contains absolute-pose, relative-pose, triangulation, and point-cloud alignment methods for the calibrated case. All problems can be solved with central or non-central cameras, and embedded into a random sample consensus or nonlinear optimization context. Matlab and Python interfaces are implemented as well.
* **[vcglib](https://github.com/cnr-isti-vclab/vcglib)**
  - The Visualization and Computer Graphics Library (VCGlib for short) is a open source, portable, C++, templated, no dependency, library for manipulation, processing, cleaning, simplifying triangle meshes.
* **[MeshLab](http://www.meshlab.net/), [github](https://github.com/cnr-isti-vclab/meshlab)**
  - MeshLab the open source system for processing and editing 3D triangular meshes. It provides a set of tools for editing, cleaning, healing, inspecting, rendering, texturing and converting meshes. It offers features for processing raw data produced by 3D digitization tools/devices and for preparing models for 3D printing.
* **[exiv2](http://www.exiv2.org/)**
  - [exiv2 download](http://www.exiv2.org/download.html), [github](https://github.com/Exiv2/exiv2)
  - Exiv2 is a Cross-platform C++ library and a command line utility to manage image metadata. It provides fast and easy read and write access to the Exif, IPTC and XMP metadata and the ICC Profile embedded within digital images in various formats. Exiv2 is available as free software and is used in many projects including KDE and Gnome Desktops as well as many applications including GIMP, darktable, shotwell, GwenView and Luminance HDR.
* **[FLANN](http://www.cs.ubc.ca/research/flann/)**
  - **What is FLANN?**
    * FLANN is a library for performing fast approximate nearest neighbor searches in high dimensional spaces. It contains a collection of algorithms we found to work best for nearest neighbor search and a system for automatically choosing the best algorithm and optimum parameters depending on the dataset.
    * FLANN is written in C++ and contains bindings for the following languages: C, MATLAB and Python.
