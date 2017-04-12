require 'spec_helper'

describe 'glare::backend::swift' do
  shared_examples_for 'glare::backend::swift' do
    let :params do
      {
        :swift_store_user => 'user',
        :swift_store_key  => 'key',
      }
    end

    let :pre_condition do
      'class { "glare::keystone::authtoken": password => "pass" }
       include ::glare'
    end

    describe 'when default parameters' do

      it { is_expected.to contain_class 'swift::client' }

      it 'configures glare.conf' do
        is_expected.to contain_glare_config('glance_store/default_store').with_value('swift')
        is_expected.to contain_glare_config('glance_store/swift_store_large_object_size').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glare_config('glance_store/swift_store_container').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glare_config('glance_store/swift_store_create_container_on_put').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glare_config('glance_store/swift_store_endpoint_type').with_value('internalURL')
        is_expected.to contain_glare_config('glance_store/swift_store_region').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_glare_config('glance_store/swift_store_config_file').with_value('/etc/glare/glare-swift.conf')
        is_expected.to contain_glare_config('glance_store/default_swift_reference').with_value('ref1')
      end

    end

    describe 'when overriding parameters' do
      let :params do
        {
          :swift_store_user                    => 'user2',
          :swift_store_key                     => 'key2',
          :swift_store_auth_version            => '1',
          :swift_store_auth_project_domain_id  => 'proj_domain',
          :swift_store_auth_user_domain_id     => 'user_domain',
          :swift_store_large_object_size       => '100',
          :swift_store_auth_address            => '127.0.0.2:8080/v1.0/',
          :swift_store_container               => 'swift',
          :swift_store_create_container_on_put => true,
          :swift_store_endpoint_type           => 'publicURL',
          :swift_store_region                  => 'RegionTwo',
          :default_swift_reference             => 'swift_creds',
        }
      end

      it 'configures glare.conf' do
        is_expected.to contain_glare_config('glance_store/swift_store_container').with_value('swift')
        is_expected.to contain_glare_config('glance_store/swift_store_create_container_on_put').with_value(true)
        is_expected.to contain_glare_config('glance_store/swift_store_large_object_size').with_value('100')
        is_expected.to contain_glare_config('glance_store/swift_store_endpoint_type').with_value('publicURL')
        is_expected.to contain_glare_config('glance_store/swift_store_region').with_value('RegionTwo')
        is_expected.to contain_glare_config('glance_store/default_swift_reference').with_value('swift_creds')
        is_expected.to contain_glare_swift_config('swift_creds/key').with_value('key2')
        is_expected.to contain_glare_swift_config('swift_creds/user').with_value('user2')
        is_expected.to contain_glare_swift_config('swift_creds/auth_version').with_value('1')
        is_expected.to contain_glare_swift_config('swift_creds/auth_address').with_value('127.0.0.2:8080/v1.0/')
        is_expected.to contain_glare_swift_config('swift_creds/user_domain_id').with_value('user_domain')
        is_expected.to contain_glare_swift_config('swift_creds/project_domain_id').with_value('proj_domain')
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

      it_configures 'glare::backend::swift'
    end
  end
end
