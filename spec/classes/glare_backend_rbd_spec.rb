require 'spec_helper'

describe 'glare::backend::rbd' do
  let (:facts) do
    OSDefaults.get_facts({
      :osfamily => 'Debian',
    })
  end

  describe 'with default params' do

    it { is_expected.to contain_glare_config('glance_store/default_store').with_value('rbd') }
    it { is_expected.to contain_glare_config('glance_store/rbd_store_pool').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_glare_config('glance_store/rbd_store_ceph_conf').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_glare_config('glance_store/rbd_store_chunk_size').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_glare_config('glance_store/rados_connect_timeout').with_value('<SERVICE DEFAULT>')}
    it { is_expected.to contain_glare_config('glance_store/rbd_store_user').with_value('<SERVICE DEFAULT>')}
    it { is_expected.to contain_package('python-ceph').with(
        :name   => 'python-ceph',
        :ensure => 'present'
      )
    }
  end

  describe 'when passing params' do
    let :params do
      {
        :rbd_store_user        => 'user',
        :rbd_store_chunk_size  => '2',
        :package_ensure        => 'latest',
        :rados_connect_timeout => '30',
      }
    end
    it { is_expected.to contain_glare_config('glance_store/rbd_store_user').with_value('user') }
    it { is_expected.to contain_glare_config('glance_store/rbd_store_chunk_size').with_value('2') }
    it { is_expected.to contain_glare_config('glance_store/rados_connect_timeout').with_value('30')}
    it { is_expected.to contain_package('python-ceph').with(
        :name   => 'python-ceph',
        :ensure => 'latest'
      )
    }
  end

  describe 'package on RedHat platform el6' do
    let :facts do
      OSDefaults.get_facts({
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '6.5',
      })
    end
    it { is_expected.to contain_package('python-ceph').with(
        :name   => 'python-ceph',
        :ensure => 'present'
      )
    }
  end
  describe 'package on RedHat platform el7' do
    let :facts do
      OSDefaults.get_facts({
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '7.0'
      })
    end
    it { is_expected.to contain_package('python-ceph').with(
        :name   => 'python-rbd',
        :ensure => 'present'
      )
    }
  end
end
