require 'spec_helper_acceptance'

describe 'yarn class' do

  describe 'running puppet code' do
    pp = <<-EOS
      class { 'nodejs': } ->
      class { 'yarn': }
    EOS
    let(:manifest) { pp }

    it 'should work with no errors' do
      apply_manifest(manifest, :catch_failures => true)
    end

    it 'should be idempotent' do
      apply_manifest(manifest, :catch_changes => true)
    end

  end

end
