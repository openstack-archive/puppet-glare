require 'spec_helper'

describe 'glare' do
  let :pre_condition do
   "class { '::glare::keystone::authtoken':
     password => 'ChangeMe' }"
  end

  shared_examples 'glare' do

    context 'with default parameters' do
      let :params do
         { :purge_config => false }
      end

      it 'contains the params class' do
        is_expected.to contain_class('glare::params')
      end

      it 'contains the db class' do
        is_expected.to contain_class('glare::db')
      end

      it 'contains the logging class' do
        is_expected.to contain_class('glare::logging')
      end

      it 'installs package' do
        is_expected.to contain_package('glare').with(
          :ensure => 'present',
          :name   => platform_params[:glare_package_name]
        )
      end

      it 'passes purge to resource' do
        is_expected.to contain_resources('glare_config').with({
          :purge => false
        })
      end

      it { is_expected.to contain_glare_config('DEFAULT/bind_host').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glare_config('DEFAULT/bind_port').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glare_config('DEFAULT/backlog').with_value('<SERVICE DEFAULT>') }

      it { is_expected.to contain_class('glare::db::sync') }

      it 'configures storage' do
        is_expected.to contain_glare_config('glance_store/os_region_name').with_value('RegionOne')
        is_expected.to contain_glare_config('glance_store/stores').with_ensure('absent')
        is_expected.not_to contain_glare_config('glance_store/default_store')
        is_expected.to contain_glare_config('glance_store/filesystem_store_datadir').with_value('/var/lib/glare/images')
      end

      it 'is_expected.to configure itself for keystone if it needed' do
        if :auth_strategy == 'keystone'
          is_expected.to contain_class('glare::authtoken')
        end
      end

      it 'configures ssl' do
        is_expected.to contain_glare_config('DEFAULT/cert_file').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glare_config('DEFAULT/key_file').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glare_config('DEFAULT/ca_file').with_value('<SERVICE DEFAULT>')
      end

      it { is_expected.to contain_service('glare').with(
          'ensure' => 'running',
          'name'   => platform_params[:glare_service_name],
          'enable' => true,
        ) }
    end

    context 'with db sync disabled' do
      let :params do
         { :sync_db => false }
      end
      it { is_expected.not_to contain_class('glare::db::sync') }
    end

  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      case facts[:osfamily]
      when 'Debian'
        let (:platform_params) do
          { :glare_package_name => 'glare-api',
            :glare_service_name => 'glare-api' }
        end
      when 'RedHat'
        let (:platform_params) do
          { :glare_package_name => 'openstack-glare',
            :glare_service_name => 'openstack-glare-api' }
        end
      end

      it_behaves_like 'glare'

    end
  end
end
