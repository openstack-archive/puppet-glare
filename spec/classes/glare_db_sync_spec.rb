require 'spec_helper'

describe 'glare::db::sync' do
  context 'exec has proper name' do
    it { is_expected.to contain_exec('glare-db-sync') }
  end

  context 'class sync default command' do
    it { is_expected.to contain_exec('glare-db-sync').with_command(
      'glare-db-manage  upgrade') }
  end

  context 'class sync work with parameters' do
    let :params do
      { :extra_params  => '-yyy' }
    end
    it { is_expected.to contain_exec('glare-db-sync').with_command('glare-db-manage -yyy upgrade') }
  end

end
