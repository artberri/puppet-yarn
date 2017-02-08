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
                    'id'     => '72ECF46A56B4AD39C907BBB71646B01B86E50310',
                    'source' => 'https://dl.yarnpkg.com/debian/pubkey.gpg',
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
          it { is_expected.to raise_error(Puppet::Error, /can not manage repo on/) }
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
