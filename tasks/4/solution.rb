RSpec.describe 'Version' do
  describe '#initialize' do
    it 'raise error for non-valid versions with string' do
      expect { Version.new('.1.2') }
      .to raise_error(ArgumentError, /Invalid version string '.1.2'/)
      expect { Version.new('1.2.') }
      .to raise_error(ArgumentError, /Invalid version string '1.2.'/)
      expect { Version.new('1..2') }
      .to raise_error(ArgumentError, /Invalid version string '1..2'/)
    end

    it 'raise error for non-valid versions with other instance' do
      expect { Version.new(Version.new('1.2.')) }
      .to raise_error(ArgumentError, /Invalid version string '1.2.'/)
    end

    it 'makes valid version with string' do
      expect { Version.new('1.2') }.to_not raise_error
      expect { Version.new('0.0') }.to_not raise_error
      expect { Version.new }.to_not raise_error
    end

    it 'makes valid version with other instance' do
      expect { Version.new(Version.new('1.2.0')) }.to_not raise_error
    end
  end

  describe '#<=>' do
    it 'can compare versions with > ' do
      expect(Version.new('1.2.3') > Version.new('1.3.1')).to eq(false)
      expect(Version.new('2.1.2') > Version.new('2.1')).to eq(true)
      expect(Version.new > Version.new('1.3.4')).to eq(false)
      expect(Version.new(Version.new('2.3.0.1')) >
        Version.new(Version.new('2.3'))
            ).to eq(true)
    end

    it 'can compare versions with < ' do
      expect(Version.new('1.2.3') < Version.new('1.3.1')).to eq(true)
      expect(Version.new('2.1.2') < Version.new('2.1')).to eq(false)
      expect(Version.new < Version.new('1.3.4')).to eq(true)
      expect(Version.new(Version.new('2.3.0.1')) <
        Version.new(Version.new('2.3'))
            ).to eq(false)
    end

    it 'can compare versions with >=' do
      expect(Version.new(Version.new('0')) >=
        Version.new(Version.new)
            ).to eq(true)
      expect(Version.new(Version.new('3.22.1')) >=
        Version.new('3.22.0')
            ).to eq(true)
    end

    it 'can compare versions with <=' do
      expect(Version.new(Version.new('0')) <=
        Version.new(Version.new)
            ).to eq(true)
      expect(Version.new(Version.new('3.21')) <=
        Version.new('2.1')
            ).to eq(false)
    end

    it 'can compare versions with ==' do
      expect(Version.new('9') == Version.new('9.0.0.0')).to eq(true)
      expect(Version.new(Version.new('0')) ==
        Version.new(Version.new)
            ).to eq(true)
      expect(Version.new(Version.new('3.21')) ==
        Version.new('2.1')
            ).to eq(false)
    end

    it 'can compare versions with <=>' do
      expect(Version.new('2.2.0.1.0.0') <=> Version.new('2.2.0.1')).to eq(0)
      expect(Version.new('1.2.3') <=> Version.new('2.1.3')).to eq(-1)
      expect(Version.new(Version.new('3.2.3')) <=>
          Version.new('2.1.3')
            ).to eq(1)
    end
  end

  describe '#to_s' do
    it 'makes canonical representation of version' do
      expect(Version.new.to_s).to eq ''
      expect(Version.new('1.2.0.0.0').to_s).to eq '1.2'
      expect(Version.new(Version.new('0.1.0')).to_s).to eq '0.1'
    end
  end

  describe '#components' do
    it 'makes an array with all version`s components' do
      expect(Version.new('1.2.3').components).to eq [1, 2, 3]
      expect(Version.new('1.2.3.0.0').components).to eq [1, 2, 3]
      expect(Version.new.components).to eq []
    end

    it 'makes an array with lesser than version`s components' do
      expect(Version.new('3.2.3.1.2').components(4)).to eq [3, 2, 3, 1]
      expect(Version.new(Version.new('0.0.1')).components(2)).to eq [0, 0]
    end

    it 'makes an array with greater than version`s components' do
      expect(Version.new('3').components(3)).to eq [3, 0, 0]
      expect(Version.new.components(2)).to eq [0, 0]
    end
  end

  describe 'Version::Range' do
    describe '#include?' do
      it 'checks that the inside of the range contains a version' do
        range = Version::Range.new(Version.new('1.9'), Version.new('2.0.2'))
        string_range = Version::Range.new('0.1', '5.9')
        expect((range.include? Version.new('2'))).to eq(true)
        expect((range.include? '1.5')).to eq(false)
        expect((string_range.include? Version.new('4.33.0.3'))).to eq(true)
      end

      it 'checks that endigns of the range contain a version' do
        range = Version::Range.new(Version.new('1.9'), Version.new('2.0.2'))
        expect((range.include? Version.new('1.9.0'))).to eq(true)
        expect((range.include? Version.new('2.0.2.0'))).to eq(false)
      end

      it 'checks if submitted version matches with range with one argument' do
        range = Version::Range.new(Version.new('1'), Version.new('1'))
        expect((range.include? Version.new('1'))).to eq(false)
      end
    end

    describe '#to_a' do
      it 'makes a range of two different versions' do
        range = Version::Range.new(Version.new('1.1.0'), Version.new('1.2'))
        .map { |item| item.to_s }

        range2 = Version::Range.new(Version.new('3.1.9'), Version.new('3.2.6'))
        .map { |item| item.to_s }

        expect(range).to eq [
          '1.1', '1.1.1', '1.1.2', '1.1.3', '1.1.4', '1.1.5', '1.1.6', '1.1.7',
          '1.1.8', '1.1.9'
        ]
        expect(range2).to eq [
          '3.1.9', '3.2', '3.2.1', '3.2.2', '3.2.3', '3.2.4', '3.2.5'
        ]
      end

      it 'makes empty array of range of same versions' do
        range = Version::Range.new(Version.new('3.1.0'), Version.new('3.1.0'))
        expect(range.to_a).to eq []
      end
    end
  end
end
