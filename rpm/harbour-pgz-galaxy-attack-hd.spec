# 
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.32
# 

Name:       harbour-pgz-galaxy-attack-hd

# >> macros
# << macros

%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}
Summary:    Space Invaders type game
Version:    1.0.9
Release:    1
Group:      Games/Action
License:    GPL v2
URL:        http://www.piggz.co.uk
Source0:    %{name}-%{version}.tar.bz2
Source100:  harbour-pgz-galaxy-attack-hd.yaml
Requires:   qt5-qtdeclarative-import-sensors
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(qdeclarative5-boostable)
BuildRequires:  pkgconfig(Qt5Svg)
BuildRequires:  desktop-file-utils

%description
Space Invaders type game written using QML

%if "%{?vendor}" == "chum"
PackageName: Galaxy Attack HD
Type: desktop-application
DeveloperName: Adam Pigg
Categories:
 - Games
Custom:
  Repo: https://github.com/piggz/galaxy-attack-hd
Icon: https://raw.githubusercontent.com/piggz/galaxy-attack-hd/master/galaxy-attack-128.png
Screenshots:
 - https://raw.githubusercontent.com/piggz/galaxy-attack-hd/master/media/Screenshot_2014-10-05-20-29-38.png
 - https://raw.githubusercontent.com/piggz/galaxy-attack-hd/master/media/Screenshot_2014-10-05-20-54-46.png
 - https://raw.githubusercontent.com/piggz/galaxy-attack-hd/master/media/amazon_featured.png
Url:
  Homepage: https://github.com/piggz/galaxy-attack-hd
  Help: https://github.com/piggz/galaxy-attack-hd/discussions
  Bugtracker: https://github.com/piggz/galaxy-attack-hd/issues
  Donation: https://www.paypal.me/piggz
%endif


%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre

%qtc_qmake5 

%qtc_make %{?_smp_mflags}

# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%qmake5_install

# >> install post
# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/86x86/apps/%{name}.png
# >> files
# << files
