require 'spec_helper'

describe 'glare::client' do

  shared_examples_for 'glare client' do

    it { is_expected.to contain_class('glare::deps') }
    it { is_expected.to contain_class('glare::params') }

    it 'installs glare client package' do
      is_expected.to contain_package('python-glareclient').with(
        :ensure => 'present',
        :name   => platform_params[:client_package_name],
        :tag    => 'openstack',
      )
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let :platform_params do
        { :client_package_name => 'python-glareclient' }
      end

      it_behaves_like 'glare client'
    end
  end

end
