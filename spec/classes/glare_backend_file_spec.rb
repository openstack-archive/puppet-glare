require 'spec_helper'

describe 'glare::backend::file' do

  shared_examples_for 'glare::backend::file' do
    it 'configures glare.conf' do
      is_expected.to contain_glare_config('glance_store/default_store').with_value('file')
      is_expected.to contain_glare_config('glance_store/filesystem_store_datadir').with_value('/var/lib/glare/images/')
    end

    describe 'when overriding datadir' do
      let :params do
        {:filesystem_store_datadir => '/tmp/'}
      end

      it 'configures glare.conf' do
        is_expected.to contain_glare_config('glance_store/filesystem_store_datadir').with_value('/tmp/')
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'glare::backend::file'
    end
  end
end
