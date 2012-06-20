$:.unshift File.join(File.dirname(__FILE__),"..","lib")
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
  end
  
  def test_srecord_crc
    test_record="S00E00005065726675736F726D6F744A"
    srec=nil
    assert_raise(S19::SRecordError) { srec=S19::SRecord.parse(test_record) }
  end
  
end
