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
  end

  describe 'compare version' do
    it 'can compare versions with <' do
      expect(Version.new('1.2.3')).to be < Version.new('1.3')
      expect(Version.new('1.3.3')).not_to be < Version.new('1.3')
      expect(Version.new('1.3.3')).not_to be < Version.new('1.3.3')
      expect(Version.new('0.3.3')).to be < Version.new('1.0.0')
      expect(Version.new('')).to be < Version.new('0.0.4')
    end
    it 'can compare versions with >' do
      expect(Version.new('1.2.3')).not_to be > Version.new('1.3')
      expect(Version.new('1.3.3')).to be > Version.new('1.3')
      expect(Version.new('1.3')).not_to be > Version.new('1.3')
      expect(Version.new('1.4')).to be > Version.new('1.3.9')
      expect(Version.new('2.3.3')).to be > Version.new('2.3.1')
      expect(Version.new('0.0')).not_to be > Version.new('0.0.4')
      expect(Version.new('0.1')).to be > Version.new('')
    end
    it 'can compare versions with >=' do
      expect(Version.new('1.3.3')).to be >= Version.new('1.3')
      expect(Version.new('1.3.3')).to be >= Version.new('1.3.2')
      expect(Version.new('1.3.3')).to be >= Version.new('1.3.3.0')
      expect(Version.new('1.2.9')).not_to be >= Version.new('1.3.3')
      expect(Version.new('1.2.9')).not_to be >= Version.new('1.2.9.1')
      expect(Version.new('1.2.9')).not_to be >= Version.new('1.3')
      expect(Version.new('')).not_to be >= Version.new('0.0.4')
      expect(Version.new('0.1')).to be >= Version.new('')
    end
    it 'can compare versions with <=' do
      expect(Version.new('1.3.3')).not_to be <= Version.new('1.3')
      expect(Version.new('1.3.3')).to be <= Version.new('1.3.3')
      expect(Version.new('1.3.3')).not_to be <= Version.new('1.3.2')
      expect(Version.new('1.3.3')).to be <= Version.new('1.3.3.0')
      expect(Version.new('1.2.9')).to be <= Version.new('1.3')
      expect(Version.new('1.4')).not_to be <= Version.new('1.3.9')
      expect(Version.new('')).to be <= Version.new('0.0.4')
      expect(Version.new('0.1')).not_to be <= Version.new('')
    end
    it 'can compare versions with ==' do
      version1 = Version.new('1.3.3')
      version2 = Version.new('1.3.3')
      expect(version1 == version2).to be true
      expect(Version.new('1.3.3.0.0') == Version.new('1.3.3')).to be true
      expect(Version.new('1.4') == Version.new('1.4.1')).to be false
      expect(Version.new('1.3.3.2') == Version.new('1.3.3.1')).to be false
      expect(Version.new('') == Version.new('0.0')).to be true
    end
    it 'can compare versions with <=>' do
      expect(Version.new('1.3.3') <=> Version.new('1.3')).to be 1
      expect(Version.new <=> Version.new('')).to be 0
      expect(Version.new('0') <=> Version.new('')).to be 0
      expect(Version.new('0') <=> Version.new('1.3')).to be -1
      expect(Version.new('0.1') <=> Version.new).to be 1
      expect(Version.new('') <=> Version.new('1.3')).to be -1
      expect(Version.new('1.3.3.0.0') <=> Version.new('1.3.3')).to be 0
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

    it 'checks if components modify the version' do
      test_obj = Version.new("1.0.0.0.0.0.0.10.0.0.0.0.0.0.0.0.0")
      test_obj.components << 123_123_21
      expect(test_obj.components).to eq [1, 0, 0, 0, 0, 0, 0, 10]
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
      it 'makes empty array of range of same versions' do
        test_obj = Version::Range.new("0.0.0", "0.0.0")
        expect(test_obj.to_a).to eq []
      end
      it 'makes range of all versions' do
        test_obj = Version::Range.new("0.0.8", "0.1.1")
        first = Version.new("0.0.8")
        middle = Version.new("0.0.9")
        last = Version.new("0.1.0")
        expect(test_obj.to_a).to eq [first, middle, last]
        test_obj = Version::Range.new("0.9.9", "1.0.1")
        first = Version.new("0.9.9")
        last = Version.new("1.0.0")
        expect(test_obj.to_a).to eq [first, last]
      end
    end
  end
end
