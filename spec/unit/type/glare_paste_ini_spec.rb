require 'puppet'
require 'puppet/type/glare_config'
describe 'Puppet::Type.type(:glare_paste_ini)' do
  before :each do
    @glare_paste_ini = Puppet::Type.type(:glare_paste_ini).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should require a name' do
    expect {
      Puppet::Type.type(:glare_paste_ini).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should not expect a name with whitespace' do
    expect {
      Puppet::Type.type(:glare_paste_ini).new(:name => 'f oo')
    }.to raise_error(Puppet::Error, /Parameter name failed/)
  end

  it 'should fail when there is no section' do
    expect {
      Puppet::Type.type(:glare_paste_ini).new(:name => 'foo')
    }.to raise_error(Puppet::Error, /Parameter name failed/)
  end

  it 'should not require a value when ensure is absent' do
    Puppet::Type.type(:glare_paste_ini).new(:name => 'DEFAULT/foo', :ensure => :absent)
  end

  it 'should accept a valid value' do
    @glare_paste_ini[:value] = 'bar'
    expect(@glare_paste_ini[:value]).to eq('bar')
  end

  it 'should not accept a value with whitespace' do
    @glare_paste_ini[:value] = 'b ar'
    expect(@glare_paste_ini[:value]).to eq('b ar')
  end

  it 'should accept valid ensure values' do
    @glare_paste_ini[:ensure] = :present
    expect(@glare_paste_ini[:ensure]).to eq(:present)
    @glare_paste_ini[:ensure] = :absent
    expect(@glare_paste_ini[:ensure]).to eq(:absent)
  end

  it 'should not accept invalid ensure values' do
    expect {
      @glare_paste_ini[:ensure] = :latest
    }.to raise_error(Puppet::Error, /Invalid value/)
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    package = Puppet::Type.type(:package).new(:name => 'glare')
    catalog.add_resource package, @glare_paste_ini
    dependency = @glare_paste_ini.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@glare_paste_ini)
    expect(dependency[0].source).to eq(package)
  end
end
