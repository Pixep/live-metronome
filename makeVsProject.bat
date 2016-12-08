@ECHO OFF
IF EXIST E:\Dev\Qt\5.7\winrt_armv7_msvc2015\bin (
	ECHO "Building from E:\Dev\Qt"
	E:\Dev\Qt\5.6\winrt_armv7_msvc2015\bin\qmake -tp vc -r LiveMetronome.pro
) ELSE (
	ECHO "Building from C:\Qt"
	C:\Qt\5.6\winrt_armv7_msvc2015\bin\qmake -tp vc -r LiveMetronome.pro
)