class DeliveryOrder < ApplicationRecord
  acts_as_tenant(:tenant)

  after_save :touch_order_group

  belongs_to :order_group
  belongs_to :transport
  belongs_to :courier, optional: true
  has_many :line_items, dependent: :destroy

  accepts_nested_attributes_for :line_items

  private

  def touch_order_group
    if order_group.present?
      order_group.touch
    else
      Rails.logger.error("OrderGroup not found for DeliveryOrder ##{id}")
    end
  end
end
