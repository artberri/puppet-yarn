require 'spec_helper'

describe 'Yarn::Install' do
  let(:title) { '/var/www/app' }

  let(:params) do
    {
      production: production
    }
  end

  context 'in development mode' do
    let(:production) { false }

    it { should compile}

    it { is_expected.to contain_exec('yarn-install-/var/www/app').with(command: 'yarn install --production=false ', unless: 'yarn check --production=false', cwd: '/var/www/app') }
  end

  context 'in production mode' do
    let(:production) { true }

    it { should compile}

    it { is_expected.to contain_exec('yarn-install-/var/www/app').with(command: 'yarn install --production=true --frozen-lockfile', unless: 'yarn check --production=true', cwd: '/var/www/app') }
  end
end
