require 'spec_helper'

describe 'glare::db' do

  shared_examples 'glare::db' do
    context 'with default parameters' do
      it { is_expected.to contain_glare_config('database/connection').with_value('sqlite:////var/lib/glare/glare.sqlite') }
      it { is_expected.to contain_glare_config('database/idle_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glare_config('database/min_pool_size').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glare_config('database/max_retries').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glare_config('database/retry_interval').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glare_config('database/max_pool_size').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_glare_config('database/max_overflow').with_value('<SERVICE DEFAULT>') }
    end

    context 'with specific parameters' do
      let :params do
        { :database_connection     => 'mysql+pymysql://glare:glare@localhost/glare',
          :database_idle_timeout   => '3601',
          :database_min_pool_size  => '2',
          :database_max_retries    => '11',
          :database_retry_interval => '11',
          :database_max_pool_size  => '11',
          :database_max_overflow   => '21',
        }
      end

      it { is_expected.to contain_glare_config('database/connection').with_value('mysql+pymysql://glare:glare@localhost/glare') }
      it { is_expected.to contain_glare_config('database/idle_timeout').with_value('3601') }
      it { is_expected.to contain_glare_config('database/min_pool_size').with_value('2') }
      it { is_expected.to contain_glare_config('database/max_retries').with_value('11') }
      it { is_expected.to contain_glare_config('database/retry_interval').with_value('11') }
      it { is_expected.to contain_glare_config('database/max_pool_size').with_value('11') }
      it { is_expected.to contain_glare_config('database/max_overflow').with_value('21') }
    end

    context 'with postgresql backend' do
      let :params do
        { :database_connection     => 'postgresql://glare:glare@localhost/glare', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-psycopg2').with(:ensure => 'present')
      end

    end

    context 'with MySQL-python library as backend package' do
      let :params do
        { :database_connection     => 'mysql://glare:glare@localhost/glare', }
      end

      it { is_expected.to contain_package('python-mysqldb').with(:ensure => 'present') }
    end

    context 'with incorrect database_connection string' do
      let :params do
        { :database_connection     => 'foodb://glare:glare@localhost/glare', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

    context 'with incorrect pymysql database_connection string' do
      let :params do
        { :database_connection     => 'foo+pymysql://glare:glare@localhost/glare', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

  end

  shared_examples_for 'glare::db on Debian' do
    context 'using pymysql driver' do
      let :params do
        { :database_connection     => 'mysql+pymysql://glare:glare@localhost/glare', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('db_backend_package').with(
          :ensure => 'present',
          :name   => 'python-pymysql',
          :tag    => 'openstack'
        )
      end
    end
  end

  shared_examples_for 'glare::db on RedHat' do
    context 'using pymysql driver' do
      let :params do
        { :database_connection     => 'mysql+pymysql://glare:glare@localhost/glare', }
      end

      it 'install the proper backend package' do
        is_expected.not_to contain_package('db_backend_package')
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

      it_configures 'glare::db'
      it_configures "glare::db on #{facts[:osfamily]}"
    end
  end
end
