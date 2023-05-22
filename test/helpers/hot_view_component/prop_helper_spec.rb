# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HotViewComponent:ResponsiveHelper, type: :helper do
  it 'returns an InvalidPropError when the prop has an invalid value' do
    classes = { foo: { _: 'bar' } }
    prop = :foo

    expect(helper.responsive_classes(prop, classes)).to eq('bar')
  end
end
