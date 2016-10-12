require 'spec_helper'

describe 'yarn', :type => :class do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with install_from_source => true' do
        let :params do {
          :install_from_source => true,
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
      end

      context 'with install_from_source => false' do
        let :params do {
          :install_from_source => false,
        }
        end

        it { is_expected.not_to contain_exec('wget https://yarnpkg.com/latest.tar.gz') }

        it { is_expected.to contain_package('yarn')
                .with_ensure('present')
        }
      end

    end
  end

end
