$:.unshift File.join(File.dirname(__FILE__),"..","lib")
require 'simplecov'
SimpleCov.start
require "test/unit"
require "rsrec"

class TestRsrec < Test::Unit::TestCase
  def test_version
    assert_equal(S19::Version::STRING, "#{S19::Version::MAJOR}.#{S19::Version::MINOR}.#{S19::Version::TINY}")
  end
  
  def test_srecord
    test_record="S00E00005065726675736F726D6F744B"
    srec=nil
    assert_nothing_raised(S19::SRecordError) { srec=S19::SRecord.parse(test_record) }
    assert_not_nil(srec)
    assert_equal(test_record, srec.to_s)
    assert_equal(0, srec.record_type)
    assert_equal(14, srec.byte_count)
    assert_equal("4B", srec.crc)
    assert(!srec.data_record?, "Not a data record")
  end
  
  def test_srecord_crc
    test_record="S00E00005065726675736F726D6F744A"
    srec=nil
    assert_raise(S19::SRecordError) { srec=S19::SRecord.parse(test_record) }
  end
  
  def test_trimming
    test_record="S00E00005065726675736F726D6F744B\n"
    assert_nothing_raised(S19::SRecordError) { S19::SRecord.parse(test_record) }
    test_record="S00E00005065726675736F726D6F744B\r"
    assert_nothing_raised(S19::SRecordError) { S19::SRecord.parse(test_record) }
    test_record="S00E00005065726675736F726D6F744B\r\n"
    assert_nothing_raised(S19::SRecordError) { S19::SRecord.parse(test_record) }
  end

  def test_format_checks
    test_record="BF00726D6F744A"
    assert_raise(S19::SRecordError) { S19::SRecord.parse(test_record) }
    assert_raise(S19::SRecordError) { S19::SRecord.new(15,0x0405,"FOO") }
  end

  def test_data_records
    test_record="S11F001C4BFFFFE5398000007D83637880010014382100107C0803A64E800020E9"
    srec=nil
    assert_nothing_raised(S19::SRecordError) { srec=S19::SRecord.parse(test_record) }
    assert(srec.data_record?, "A data record")
    test_record="S5030003F9"
    assert_nothing_raised(S19::SRecordError) { srec=S19::SRecord.parse(test_record) }
    assert(!srec.data_record?, "Not a data record")
    test_record="S9030000FC"
    assert_nothing_raised(S19::SRecordError) { srec=S19::SRecord.parse(test_record) }
    assert(!srec.data_record?, "Not a data record")
  end
end
