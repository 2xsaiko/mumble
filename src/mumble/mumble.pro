include(../mumble.pri)

TEMPLATE	= app
QT		*= network sql opengl xml
TARGET		= mumble
HEADERS		= BanEditor.h ACLEditor.h Log.h AudioConfigDialog.h AudioStats.h AudioInput.h AudioOutput.h MainWindow.h ServerHandler.h About.h ConnectDialog.h GlobalShortcut.h TextToSpeech.h Settings.h Database.h VersionCheck.h Global.h PlayerModel.h Audio.h ConfigDialog.h Plugins.h LookConfig.h Overlay.h  AudioWizard.h ViewCert.h TextMessage.h NetworkConfig.h LCD.h Usage.h
SOURCES		= BanEditor.cpp ACLEditor.cpp Log.cpp AudioConfigDialog.cpp AudioStats.cpp AudioInput.cpp AudioOutput.cpp main.cpp MainWindow.cpp ServerHandler.cpp About.cpp ConnectDialog.cpp Settings.cpp Database.cpp VersionCheck.cpp Global.cpp PlayerModel.cpp Audio.cpp ConfigDialog.cpp Plugins.cpp LookConfig.cpp Overlay.cpp AudioWizard.cpp ViewCert.cpp Messages.cpp TextMessage.cpp GlobalShortcut.cpp NetworkConfig.cpp LCD.cpp Usage.cpp
HEADERS	*= ../ACL.h ../Group.h ../Channel.h ../Connection.h ../Player.h
SOURCES *= ../ACL.cpp ../Group.cpp ../Channel.cpp ../Message.cpp ../Connection.cpp ../Player.cpp ../Timer.cpp ../CryptState.cpp
SOURCES *= smallft.cpp
DIST		*= licenses.h smallft.h mumble.ico mumble.xpm plugins/mumble_plugin.h mumble-overlay mumble.desktop mumble.protocol murmur_pch.h 11-input-mumble-policy.fdi mumble.plist
RESOURCES	*= mumble.qrc
FORMS	*= ConfigDialog.ui MainWindow.ui ConnectDialog.ui BanEditor.ui ACLEditor.ui Plugins.ui Overlay.ui LookConfig.ui AudioInput.ui AudioOutput.ui Log.ui TextMessage.ui AudioStats.ui NetworkConfig.ui LCD.ui
TRANSLATIONS	= mumble_en.ts mumble_es.ts mumble_de.ts mumble_tr.ts mumble_fr.ts mumble_ru.ts mumble_cs.ts mumble_ja.ts mumble_pl.ts
PRECOMPILED_HEADER = mumble_pch.hpp

CONFIG(no-bundled-speex) {
  PKGCONFIG	*= speex speexdsp
}

!CONFIG(no-bundled-speex) {
  INCLUDEPATH	*= ../../speex/include ../../speex/libspeex ../../speexbuild
  LIBS 		*= -lspeex
}

!win32 {
  QMAKE_CXXFLAGS	*= -Wall -Wextra
}

!CONFIG(no-dbus) {
  CONFIG		*= dbus
}

!CONFIG(no-g15) {
  CONFIG *= g15
}

win32 {
  RC_FILE	= mumble.rc
  HEADERS	*= GlobalShortcut_win.h
  SOURCES	*= GlobalShortcut_win.cpp TextToSpeech_win.cpp Overlay_win.cpp os_win.cpp
  LIBS		*= -ldxguid -ldinput8 -lsapi -lole32 -lws2_32 -llibeay32 -ladvapi32
  LIBPATH	*= /dev/WinSDK/Lib/i386 /dev/dxsdk/Lib/x86 /dev/OpenSSL/lib
  DEFINES	*= WIN32
  INCLUDEPATH	*= /dev/OpenSSL/include
  !CONFIG(no-asio) {
    CONFIG	*= asio
  }
  !CONFIG(no-directsound) {
    CONFIG	*= directsound
  }
  !CONFIG(no-wasapi) {
    CONFIG	*= wasapi
  }
}

unix {
  UNAME=$$system(uname -s)

  HAVE_PULSEAUDIO=$$system(pkg-config --modversion --silence-errors libpulse)
  HAVE_PORTAUDIO=$$system(pkg-config --modversion --silence-errors portaudio-2.0)
  HAVE_XEVIE=$$system(pkg-config --modversion --silence-errors xevie)

  !isEmpty(HAVE_PORTAUDIO):!CONFIG(no-portaudio) {
    CONFIG *= portaudio
  }

  !isEmpty(HAVE_PULSEAUDIO):!CONFIG(no-pulseaudio) {
    CONFIG -= portaudio
    CONFIG *= pulseaudio
  }

  !isEmpty(HAVE_XEVIE):!CONFIG(no-xevie) {
    CONFIG *= xevie
  }

  !CONFIG(no-bundled-speex) {
    QMAKE_CFLAGS *= -I../../speex/include -I../../speexbuild
    QMAKE_CXXFLAGS *= -I../../speex/include -I../../speexbuild
    QMAKE_CXXFLAGS_RELEASE *= -I../../speex/include -I../../speexbuild
    QMAKE_CXXFLAGS_DEBUG *= -I../../speex/include -I../../speexbuild
  }

  CONFIG *= link_pkgconfig

  PKGCONFIG *= openssl

  contains(UNAME, Linux) {
    !CONFIG(no-oss) {
      CONFIG  *= oss
    }

    !CONFIG(no-alsa) {
      CONFIG *= alsa
    }

    !CONFIG(no-speechd) {
      CONFIG *= speechd
    }

    HEADERS *= GlobalShortcut_unix.h
    SOURCES *= GlobalShortcut_unix.cpp TextToSpeech_unix.cpp Overlay_unix.cpp
  }

  macx {
    TARGET = Mumble
    ICON = ../../icons/mumble.icns
    QMAKE_INFO_PLIST = mumble.plist
    QMAKE_PKGINFO_TYPEINFO = MBLE

    HEADERS *= GlobalShortcut_macx.h
    SOURCES *= TextToSpeech_macx.cpp
    SOURCES *= Overlay_macx.cpp
    SOURCES *= GlobalShortcut_macx.cpp
    SOURCES *= os_macx.cpp
  }
}

alsa {
	PKGCONFIG *= alsa
	HEADERS *= ALSAAudio.h
	SOURCES *= ALSAAudio.cpp
}

oss {
	HEADERS *= OSS.h
	SOURCES *= OSS.cpp
	INCLUDEPATH *= /usr/lib/oss/include
}

pulseaudio {
	PKGCONFIG *= libpulse
	HEADERS *= PulseAudio.h
	SOURCES *= PulseAudio.cpp
}

portaudio {
	PKGCONFIG *= portaudio-2.0
	HEADERS *= PAAudio.h
	SOURCES *= PAAudio.cpp
}

asio {
	HEADERS *= ASIOInput.h
	SOURCES	*= ASIOInput.cpp
	FORMS *= ASIOInput.ui
	INCLUDEPATH *= ../../asio/common ../../asio/host ../../asio/host/pc
}

dbus {
	CONFIG *= qdbus
	HEADERS *= DBus.h
	SOURCES *= DBus.cpp
	DEFINES *= USE_DBUS
}

speechd {
	DEFINES *= USE_SPEECHD
	LIBS *= -lspeechd
}

xevie {
	DEFINES *= USE_XEVIE
	PKGCONFIG *= xevie
}

directsound {
	HEADERS	*= DXAudioInput.h DXAudioOutput.h
	SOURCES	*= DXAudioInput.cpp DXAudioOutput.cpp
	LIBS	*= -ldsound
}

wasapi {
	HEADERS	*= WASAPI.h
	SOURCES	*= WASAPI.cpp
	LIBS	*= -ldelayimp -lAVRT -delayload:AVRT.DLL
}

g15 {
	win32 {
		SOURCES *= G15LCDEngine_win.cpp
		HEADERS *= G15LCDEngine_win.h ../../g15helper/g15helper.h
	}

	unix {
		SOURCES *= G15LCDEngine_unix.cpp
		HEADERS *= G15LCDEngine_unix.h
		LIBS *= -lg15daemon_client
	}
} else {
	DEFINES *= NO_G15
}

CONFIG(no-update) {
	DEFINES *= NO_UPDATE_CHECK
}

!CONFIG(no-embed-qt-translations) {
	QT_TRANSDIR = $$[QT_INSTALL_TRANSLATIONS]/
	QT_TRANSDIR = $$replace(QT_TRANSDIR,/,$${DIR_SEPARATOR})

	QT_TRANSLATION_FILES *= qt_de.qm qt_es.qm qt_fr.qm qt_ru.qm qt_pl.qm qt_ja_jp.qm

	copytrans.output = ${QMAKE_FILE_NAME}
	copytrans.commands = $$QMAKE_COPY $${QT_TRANSDIR}${QMAKE_FILE_NAME} ${QMAKE_FILE_OUT}
	copytrans.input = QT_TRANSLATION_FILES
	copytrans.CONFIG *= no_link target_predeps
	
	RESOURCES *= mumble_qt.qrc
}

lrel.output = ${QMAKE_FILE_BASE}.qm
lrel.commands = lrelease -compress -nounfinished -removeidentical ${QMAKE_FILE_NAME} 
lrel.input = TRANSLATIONS
lrel.CONFIG *= no_link target_predeps

QMAKE_EXTRA_COMPILERS += copytrans lrel
