require 'spec_helper'

module Resync
  module XML
    describe Ln do
      def parse(xml_string)
        doc = REXML::Document.new(xml_string)
        Ln.load_from_xml(doc.root)
      end

      it 'parses a tag' do
        ln = parse('<ln/>')
        expect(ln).to be_an(Ln)
      end

      it 'parses a namespaced tag' do
        ln = parse('<rs:ln xmlns:rs="http://www.openarchives.org/rs/terms/"/>')
        expect(ln).to be_an(Ln)
      end

      it 'parses @encoding' do
        ln = parse('<ln encoding="utf-8"/>')
        expect(ln.encoding).to eq('utf-8')
      end

      describe 'parses @hash' do
        it 'parses a single value' do
          ln = parse('<ln hash="md5:1e0d5cb8ef6ba40c99b14c0237be735e"/>')
          expect(ln.hashes).to eq('md5' => '1e0d5cb8ef6ba40c99b14c0237be735e')
        end

        it 'parses multiple values' do
          ln = parse('<ln hash="md5:1e0d5cb8ef6ba40c99b14c0237be735e
                                sha-256:854f61290e2e197a11bc91063afce22e43f8ccc655237050ace766adc68dc784"/>')
          expect(ln.hashes).to eq('md5' => '1e0d5cb8ef6ba40c99b14c0237be735e', 'sha-256' => '854f61290e2e197a11bc91063afce22e43f8ccc655237050ace766adc68dc784')
        end
      end

      it 'parses @href' do
        ln = parse('<ln href="http://example.org/"/>')
        expect(ln.href).to eq(URI('http://example.org/'))
      end

      it 'parses @length' do
        ln = parse('<ln length="17"/>')
        expect(ln.length).to eq(17)
      end

      it 'parses @modified' do
        ln = parse('<ln modified="2013-01-03T09:00:00Z"/>')
        expect(ln.modified_time).to eq(Time.utc(2013, 1, 3, 9))
      end

      it 'parses @path' do
        ln = parse('<ln path="/foo"/>')
        expect(ln.path).to eq('/foo')
      end

      it 'parses @pri' do
        ln = parse('<ln pri="3.14159"/>')
        expect(ln.priority).to eq(3.14159)
      end

      it 'parses @rel' do
        ln = parse('<ln rel="elvis"/>')
        expect(ln.rel).to eq('elvis')
      end

      it 'parses @type' do
        ln = parse('<ln type="elvis/presley"/>')
        expect(ln.mime_type).to be_mime_type('elvis/presley')
      end

      it 'can round-trip to XML' do
        xml = '<ln
                encoding="utf-8"
                hash="md5:1e0d5cb8ef6ba40c99b14c0237be735e"
                href="http://example.org/"
                length="12345"
                modified="2013-01-03T09:00:00Z"
                path="/foo/"
                pri="3.14159"
                rel="bar"
                type="baz/qux"
            />'
        ln = parse(xml)
        expect(ln.save_to_xml).to be_xml(xml)
      end
    end
  end
end
