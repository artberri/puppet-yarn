require 'spec_helper'

describe 'yarn', :type => :class do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with default params' do

        it { should contain_class('stdlib') }

        it { should contain_class('yarn::params') }

        case facts[:osfamily]
        when 'Debian'
          it { should contain_class('yarn::repo')
                  .with_manage_repo(true)
          }
        when 'RedHat'
          it { should contain_class('yarn::repo')
                  .with_manage_repo(true)
          }
        else
          it { should contain_class('yarn::repo')
                  .with_manage_repo(false)
          }
        end

        case facts[:osfamily]
        when 'Windows'
          it { should contain_class('yarn::install')
                  .with_package_ensure('present')
                  .with_package_name('yarn')
                  .with_install_from_source(false)
                  .with_source_install_dir('/opt')
          }
        when 'Debian'
          it { should contain_class('yarn::install')
                  .with_package_ensure('present')
                  .with_package_name('yarn')
                  .with_install_from_source(false)
                  .with_source_install_dir('/opt')
          }
        when 'RedHat'
          it { should contain_class('yarn::install')
                  .with_package_ensure('present')
                  .with_package_name('yarn')
                  .with_install_from_source(false)
                  .with_source_install_dir('/opt')
          }
        else
          it { should contain_class('yarn::install')
                  .with_package_ensure('present')
                  .with_package_name('yarn')
                  .with_install_from_source(true)
                  .with_source_install_dir('/opt')
          }
        end

      end

      context 'with manage_repo => true' do
        let :params do {
          :manage_repo => true,
        }
        end

        it { should contain_class('yarn::repo')
                .with_manage_repo(true)
        }
      end

      context 'with manage_repo => false' do
        let :params do {
          :manage_repo => true,
        }
        end

        it { should contain_class('yarn::repo')
                .with_manage_repo(true)
        }
      end

      context 'with install_from_source => true' do
        let :params do {
          :install_from_source => true,
        }
        end

        it { should contain_class('yarn::install')
                .with_install_from_source(true)
        }
      end

      context 'with install_from_source => false' do
        let :params do {
          :install_from_source => false,
        }
        end

        it { should contain_class('yarn::install')
                .with_install_from_source(false)
        }
      end

      context 'with package_ensure => dummy' do
        let :params do {
          :package_ensure => 'dummy',
        }
        end

        it { should contain_class('yarn::install')
                .with_package_ensure('dummy')
        }
      end

      context 'with package_name => dummy' do
        let :params do {
          :package_name => 'dummy',
        }
        end

        it { should contain_class('yarn::install')
                .with_package_name('dummy')
        }
      end

      context 'with source_install_dir => dummy' do
        let :params do {
          :source_install_dir => 'dummy',
        }
        end

        it { should contain_class('yarn::install')
                .with_source_install_dir('dummy')
        }
      end
    end
  end

end
