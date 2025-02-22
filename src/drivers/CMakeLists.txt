
list( APPEND _drivers_srcs
# basic
  BaseDriver.h BinaryDriver.h PostScriptDriver.h DriverManager.h
  System.h BaseDriverImages.h BaseDriverWind.h BaseDriverSymbols.h 
  BaseDriver.cc DriverManager.cc BinaryDriver.cc PostScriptDriver.cc
  KMLDriver.h  KMLDriver.cc
  GeoJsonDriver.h  GeoJsonDriver.cc
  SVGDriver.h  SVGDriver.cc
# minizip
  minizip/ioapi.c minizip/zip.c
  minizip/ioapi.h minizip/zip.h minizip/crypt.h
)

if( qt )
   list( APPEND _drivers_srcs
          QtDriver.h QtDriver.cc
          MgQ/MgQ.h
          MgQ/MgQLayoutItem.h MgQ/MgQStepItem.h
          MgQ/MgQLayerItem.h MgQ/MgQPlotScene.h
          MgQ/MgQSymbol.h MgQ/MgQPixmapItem.h MgQ/MgQPathItem.h
          MgQ/MgQTextItem.h MgQ/MgQDriverObject.h
          MgQ/MgQPolylineSetItem.h MgQ/MgQScene.h MgQ/MgQSceneItem.h
          MgQ/MgQSceneCacheItem.h MgQ/MgQStepMetaData.h
          MgQ/MgQPattern.h MgQ/MgQHistoItem.h MgQ/MgQRootItem.h
          MgQ/MgQPlotScene.cc
          MgQ/MgQLayoutItem.cc MgQ/MgQStepItem.cc
          MgQ/MgQLayerItem.cc
          MgQ/MgQSymbol.cc MgQ/MgQPixmapItem.cc MgQ/MgQPathItem.cc
          MgQ/MgQTextItem.cc
          MgQ/MgQPolylineSetItem.cc MgQ/MgQScene.cc MgQ/MgQSceneItem.cc
          MgQ/MgQSceneCacheItem.cc MgQ/MgQStepMetaData.cc
          MgQ/MgQPattern.cc MgQ/MgQHistoItem.cc
   )
   set (qt_files_HEADERS MgQ/MgQPlotScene.h)
   if( MAGICS_QT5 )
     QT5_WRAP_CPP(qt_files_HEADERS_MOC ${qt_files_HEADERS})
   else()
     QT4_WRAP_CPP(qt_files_HEADERS_MOC ${qt_files_HEADERS})
   endif()
   list( APPEND qt_srcs   ${qt_files_HEADERS_MOC})
endif()

if( HAVE_CAIRO )
  list( APPEND _drivers_srcs CairoDriver.h CairoDriver.cc )
endif()

if ( metview )
   list (APPEND metview_include
	drivers/DriverManager.h
	drivers/BaseDriver.h
	${CMAKE_CURRENT_BINARY_DIR}/../params/BaseDriverAttributes.h
	)
   set( metview_include ${metview_include} PARENT_SCOPE )
endif()

if ( qt )
   list (APPEND metview_include
	drivers/MgQ/MgQPlotScene.h
	drivers/MgQ/MgQScene.h
	drivers/QtDriver.h
	drivers/MgQ/MgQLayoutItem.h
	drivers/MgQ/MgQ.h
	drivers/MgQ/MgQSceneItem.h
	drivers/MgQ/MgQLayerItem.h
	drivers/MgQ/MgQRootItem.h
	drivers/MgQ/MgQStepMetaData.h
	)
   set( metview_include ${metview_include} PARENT_SCOPE )
endif()


if( MAGICS_RASTER )
  list( APPEND _drivers_srcs   GDDriver.h  GDDriver.cc )
endif()

foreach( file ${_drivers_srcs} )
  list( APPEND drivers_srcs drivers/${file} )
endforeach()

set( CMAKE_C_FLAGS "-std=c99 -DNO_ADDFILEINEXISTINGZIP")
set( drivers_srcs ${drivers_srcs} PARENT_SCOPE )
