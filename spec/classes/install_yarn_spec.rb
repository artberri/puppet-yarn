require 'spec_helper'

describe 'yarn', :type => :class do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with install_method => source' do
        let :params do {
          :install_method => 'source',
          :manage_repo => false,
        }
        end

        it { is_expected.to contain_file('/opt/yarn')
                  .with_ensure('directory')
                  .with_owner('root')
        }

        it { is_expected.to contain_exec('wget https://yarnpkg.com/latest.tar.gz')
                  .with_command('wget https://yarnpkg.com/latest.tar.gz -O yarn.tar.gz')
                  .with_cwd('/opt/yarn')
                  .with_user('root')
                  .with_creates('/opt/yarn/yarn.tar.gz')
        }

        it { is_expected.to contain_exec('tar zvxf yarn.tar.gz')
                  .with_command('tar zvxf yarn.tar.gz')
                  .with_cwd('/opt/yarn')
                  .with_user('root')
                  .with_creates('/opt/yarn/dist')
        }

        it { is_expected.to contain_file('/usr/local/bin/yarn')
                  .with_ensure('link')
                  .with_owner('root')
                  .with_target('/opt/yarn/dist/bin/yarn')
        }

        it { is_expected.not_to contain_package('yarn') }
        it { is_expected.not_to contain_exec('npm install -g yarn') }
      end

      context 'with install_method => source & package_ensure => absent' do
        let :params do {
          :install_method => 'source',
          :manage_repo => false,
          :package_ensure => 'absent',
        }
        end

        it { is_expected.to contain_file('/opt/yarn')
                  .with_ensure('absent')
                  .with_force(true)
        }

        it { is_expected.to contain_file('/usr/local/bin/yarn')
                  .with_ensure('absent')
        }

        it { is_expected.not_to contain_package('yarn') }
        it { is_expected.not_to contain_exec('npm install -g yarn') }
      end

      context 'with install_method => package' do
        let :params do {
          :install_method => 'package',
        }
        end

        it { is_expected.to contain_package('yarn')
                .with_ensure('present')
        }

        it { is_expected.not_to contain_exec('wget https://yarnpkg.com/latest.tar.gz') }
        it { is_expected.not_to contain_exec('npm install -g yarn') }
      end

      context 'with install_method => package & package_ensure => absent' do
        let :params do {
          :install_method => 'package',
          :package_ensure => 'absent',
        }
        end

        it { is_expected.to contain_package('yarn')
                .with_ensure('absent')
        }

        it { is_expected.not_to contain_exec('wget https://yarnpkg.com/latest.tar.gz') }
        it { is_expected.not_to contain_exec('npm install -g yarn') }
      end

      context 'with install_method => npm' do
        let :params do {
          :install_method => 'npm',
          :manage_repo    => false,
        }
        end

        it { is_expected.to contain_exec('npm install -g yarn')
                .with_command('npm install -g yarn')
                .with_provider('shell')
                .with_user('root')
                .with_unless('npm list -depth 0 -g yarn')
        }

        it { is_expected.not_to contain_exec('wget https://yarnpkg.com/latest.tar.gz') }
        it { is_expected.not_to contain_package('yarn') }
      end

      context 'with install_method => npm & package_ensure => absent' do
        let :params do {
          :install_method => 'npm',
          :manage_repo    => false,
          :package_ensure => 'absent',
        }
        end

        it { is_expected.to contain_exec('npm uninstall -g yarn')
                .with_command('npm uninstall -g yarn')
                .with_provider('shell')
                .with_user('root')
                .with_onlyif('npm list -depth 0 -g yarn')
        }

        it { is_expected.not_to contain_exec('wget https://yarnpkg.com/latest.tar.gz') }
        it { is_expected.not_to contain_package('yarn') }
      end

    end
  end

end
