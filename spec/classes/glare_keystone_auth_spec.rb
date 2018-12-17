#
# Unit tests for glare::keystone::auth
#

require 'spec_helper'

describe 'glare::keystone::auth' do
  shared_examples_for 'glare-keystone-auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'glare_password',
          :tenant   => 'foobar' }
      end

      it { is_expected.to contain_keystone_user('glare').with(
        :ensure   => 'present',
        :password => 'glare_password',
      ) }

      it { is_expected.to contain_keystone_user_role('glare@foobar').with(
        :ensure  => 'present',
        :roles   => ['admin']
      )}

      it { is_expected.to contain_keystone_service('glare::artifact').with(
        :ensure      => 'present',
        :description => 'Glare Artifact Repository Service'
      ) }

      it { is_expected.to contain_keystone_endpoint('RegionOne/glare::artifact').with(
        :ensure       => 'present',
        :public_url   => 'http://127.0.0.1:9494',
        :admin_url    => 'http://127.0.0.1:9494',
        :internal_url => 'http://127.0.0.1:9494',
      ) }
    end

    context 'when overriding URL parameters' do
      let :params do
        { :password     => 'glare_password',
          :public_url   => 'https://10.10.10.10:80',
          :internal_url => 'http://10.10.10.11:81',
          :admin_url    => 'http://10.10.10.12:81', }
      end

      it { is_expected.to contain_keystone_endpoint('RegionOne/glare::artifact').with(
        :ensure       => 'present',
        :public_url   => 'https://10.10.10.10:80',
        :internal_url => 'http://10.10.10.11:81',
        :admin_url    => 'http://10.10.10.12:81',
      ) }
    end

    context 'when overriding auth name' do
      let :params do
        { :password => 'foo',
          :auth_name => 'glarey' }
      end

      it { is_expected.to contain_keystone_user('glarey') }
      it { is_expected.to contain_keystone_user_role('glarey@services') }
      it { is_expected.to contain_keystone_service('glare::artifact') }
      it { is_expected.to contain_keystone_endpoint('RegionOne/glare::artifact') }
    end

    context 'when overriding service name' do
      let :params do
        { :service_name => 'glare_service',
          :auth_name    => 'glare',
          :password     => 'glare_password' }
      end

      it { is_expected.to contain_keystone_user('glare') }
      it { is_expected.to contain_keystone_user_role('glare@services') }
      it { is_expected.to contain_keystone_service('glare_service::artifact') }
      it { is_expected.to contain_keystone_endpoint('RegionOne/glare_service::artifact') }
    end

    context 'when disabling user configuration' do

      let :params do
        {
          :password       => 'glare_password',
          :configure_user => false
        }
      end

      it { is_expected.not_to contain_keystone_user('glare') }
      it { is_expected.to contain_keystone_user_role('glare@services') }
      it { is_expected.to contain_keystone_service('glare::artifact').with(
        :ensure      => 'present',
        :description => 'Glare Artifact Repository Service'
      ) }

    end

    context 'when disabling user and user role configuration' do

      let :params do
        {
          :password            => 'glare_password',
          :configure_user      => false,
          :configure_user_role => false
        }
      end

      it { is_expected.not_to contain_keystone_user('glare') }
      it { is_expected.not_to contain_keystone_user_role('glare@services') }
      it { is_expected.to contain_keystone_service('glare::artifact').with(
        :ensure      => 'present',
        :description => 'Glare Artifact Repository Service'
      ) }

    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'glare-keystone-auth'
    end
  end
end
