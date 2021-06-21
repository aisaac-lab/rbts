require 'rbts'
require 'pry'

include Rbts

describe Rbts do
  it "version" do
    expect(Rbts::VERSION).to eql('0.1.0')
  end

  example do
    expect(null.match?(nil)).to eq(true)
    expect(null.match?(1)).to eq(false)

    expect(number.match?(nil)).to eq(false)
    expect(number.match?(1)).to eq(true)

    expect(string.match?(nil)).to eq(false)
    expect(string.match?(1)).to eq(false)
    expect(string.match?('1')).to eq(true)

    expect((number | null).match?(nil)).to eq(true)
    expect((number | null).match?(1)).to eq(true)
    expect((number | null).match?('1')).to eq(false)

    expect((number | null).to_s).to eq('number | null')

    t1 = Rbts.typenize({
      key1: number,
      key2: string | null
    })

    expect(t1.match?({
      key1: 3,
      key2: '1'
    })).to eq(true)

    expect(t1.match?({
      key1: 3,
      key2: nil
    })).to eq(true)

    expect(t1.match?({
      key1: 3,
      key2: 1
    })).to eq(false)

    expect(t1.to_s).to eq('{ key1: number, key2: string | null }')

    t2 = number[]

    expect(t2.match?([3, 2])).to eq(true)
    expect(t2.match?([3, '1'])).to eq(false)

    expect(t2.to_s).to eq('number[]')

    t3 = Rbts.typenize({
      key1: number[],
      key2: {
        key2_1: string[],
        key2_2: number | null
      }
    })

    expect(t3.match?({
      key1: [2,3,4],
    })).to eq(false)

    expect(t3.match?({
      key1: [2,3,4],
      key2: {
        key2_1: '2',
        key2_2: nil
      }
    })).to eq(false)

    expect(t3.match?({
      key1: [2,3,4],
      key2: {
        key2_1: ['2'],
        key2_2: nil
      }
    })).to eq(true)

    expect(t3.to_s).to eq('{ key1: number[], key2: { key2_1: string[], key2_2: number | null } }')
  end
end