require 'spec_helper'

describe 'yarn', :type => :class do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with manage_repo => true' do
        let :params do {
          :manage_repo => true,
        }
        end

        case facts[:osfamily]
        when 'Debian'
          it { is_expected.to contain_apt__source('yarn')
                  .with_comment('Yarn source')
                  .with_location('http://dl.yarnpkg.com/debian/')
                  .with_release('stable')
                  .with_repos('main')
                  .with_key({
                    'id'     => 'D101F7899D41F3C3',
                    'server' => 'pgp.mit.edu',
                  })
          }
          it { is_expected.not_to contain_yumrepo('yarn') }
        when 'RedHat'
          it { is_expected.not_to contain_apt__source('yarn') }
          it { is_expected.to contain_yumrepo('yarn')
                  .with_descr('Yarn Repository')
                  .with_baseurl('https://dl.yarnpkg.com/rpm/')
                  .with_gpgkey('https://dl.yarnpkg.com/rpm/pubkey.gpg')
                  .with_gpgcheck(1)
                  .with_enabled(1)
          }
        else
          it { is_expected.not_to contain_apt__source('yarn') }
          it { is_expected.not_to contain_yumrepo('yarn') }
        end

      end

      context 'with manage_repo => false' do
        let :params do {
          :manage_repo => false,
        }
        end

        it { is_expected.not_to contain_apt__source('yarn') }
        it { is_expected.not_to contain_yumrepo('yarn') }
      end

    end
  end

end
