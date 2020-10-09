require 'spec_helper'

describe 'glare::db::mysql' do

  let :pre_condition do
    'include mysql::server'
  end

  let :required_params do
    { :password => 'glarepass', }
  end

  shared_examples_for 'glare::db::mysql' do
    context 'with only required params' do
      let :params do
        required_params
      end

      it { is_expected.to contain_class('glare::deps') }

      it { is_expected.to contain_openstacklib__db__mysql('glare').with(
        :user     => 'glare',
        :password => 'glarepass',
        :dbname   => 'glare',
        :host     => '127.0.0.1',
        :charset  => 'utf8',
        :collate  => 'utf8_general_ci',
      )}
    end

    context 'overriding allowed_hosts param to array' do
      let :params do
        { :allowed_hosts => ['127.0.0.1','%'] }.merge(required_params)
      end

      it { is_expected.to contain_openstacklib__db__mysql('glare').with(
        :user          => 'glare',
        :password      => 'glarepass',
        :dbname        => 'glare',
        :host          => '127.0.0.1',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
        :allowed_hosts => ['127.0.0.1','%']
      )}
    end

    describe 'overriding allowed_hosts param to string' do
      let :params do
        { :allowed_hosts => '192.168.1.1' }.merge(required_params)
      end

      it { is_expected.to contain_openstacklib__db__mysql('glare').with(
        :user          => 'glare',
        :password      => 'glarepass',
        :dbname        => 'glare',
        :host          => '127.0.0.1',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
        :allowed_hosts => '192.168.1.1'
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'glare::db::mysql'
    end
  end
end
