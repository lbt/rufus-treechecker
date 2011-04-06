#
# spec file for package rubygem-rufus-treechecker
#
# Copyright (c) 2011 SUSE LINUX Products GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#

# norootforbuild
Name:           rubygem-rufus-treechecker
Version:        1.0.4
Release:        0
%define mod_name rufus-treechecker
#
Group:          Development/Languages/Ruby
License:        MIT
#
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
BuildRequires:  rubygems_with_buildroot_patch
%rubygems_requires
BuildRequires:  rubygem-ruby_parser >= 2.0.5
Requires:       rubygem-ruby_parser >= 2.0.5
#
Url:            http://rufus.rubyforge.org
Source:         %{mod_name}-%{version}.gem
#
Summary:        tests strings of Ruby code for unauthorized patterns (exit, eval, ...)
%description

    tests strings of Ruby code for unauthorized patterns (exit, eval, ...)
  

%package doc
Summary:        RDoc documentation for %{mod_name}
Group:          Development/Languages/Ruby
Requires:       %{name} = %{version}
%description doc
Documentation generated at gem installation time.
Usually in RDoc and RI formats.

%package testsuite
Summary:        Test suite for %{mod_name}
Group:          Development/Languages/Ruby
Requires:       %{name} = %{version}
%description testsuite
Test::Unit or RSpec files, useful for developers.

%prep
%build
%install
%gem_install %{S:0}

%clean
%{__rm} -rf %{buildroot}

%files
%defattr(-,root,root,-)
%{_libdir}/ruby/gems/%{rb_ver}/cache/%{mod_name}-%{version}.gem
%{_libdir}/ruby/gems/%{rb_ver}/gems/%{mod_name}-%{version}/
%exclude %{_libdir}/ruby/gems/%{rb_ver}/gems/%{mod_name}-%{version}/test
%exclude %{_libdir}/ruby/gems/%{rb_ver}/gems/%{mod_name}-%{version}/spec
%{_libdir}/ruby/gems/%{rb_ver}/specifications/%{mod_name}-%{version}.gemspec

%files doc
%defattr(-,root,root,-)
%doc %{_libdir}/ruby/gems/%{rb_ver}/doc/%{mod_name}-%{version}/

%files testsuite
%defattr(-,root,root,-)
%{_libdir}/ruby/gems/%{rb_ver}/gems/%{mod_name}-%{version}/test
%{_libdir}/ruby/gems/%{rb_ver}/gems/%{mod_name}-%{version}/spec

%changelog
