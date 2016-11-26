IF EXIST E:\Dev\Qt\5.7\winrt_armv7_msvc2015\bin\qmake (
	E:\Dev\Qt\5.7\winrt_armv7_msvc2015\bin\qmake -tp vc Metronome.pro
) ELSE (
	REM -spec win32-msvc2015
	C:\Qt\5.7\winrt_armv7_msvc2015\bin\qmake -tp vc -r Metronome.pro
)