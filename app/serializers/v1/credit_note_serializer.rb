# frozen_string_literal: true

module V1
  class CreditNoteSerializer < ModelSerializer
    def serialize
      payload = {
        lago_id: model.id,
        sequential_id: model.sequential_id,
        number: model.number,
        lago_invoice_id: model.invoice_id,
        invoice_number: model.invoice.number,
        issuing_date: model.issuing_date.iso8601,
        credit_status: model.credit_status,
        refund_status: model.refund_status,
        reason: model.reason,
        description: model.description,
        currency: model.currency,
        total_amount_cents: model.total_amount_cents,
        vat_amount_cents: model.vat_amount_cents,
        sub_total_vat_excluded_amount_cents: model.sub_total_vat_excluded_amount_cents,
        balance_amount_cents: model.balance_amount_cents,
        credit_amount_cents: model.credit_amount_cents,
        refund_amount_cents: model.refund_amount_cents,
        coupons_adjustment_amount_cents: model.coupons_adjustment_amount_cents,
        created_at: model.created_at.iso8601,
        updated_at: model.updated_at.iso8601,
        file_url: model.file_url,
      }.merge(legacy_values)

      payload = payload.merge(customer) if include?(:customer)
      payload = payload.merge(items) if include?(:items)

      payload
    end

    private

    def customer
      {
        customer: ::V1::CustomerSerializer.new(model.customer).serialize,
      }
    end

    def items
      ::CollectionSerializer.new(
        model.items.order(created_at: :asc),
        ::V1::CreditNoteItemSerializer,
        collection_name: 'items',
      ).serialize
    end

    def legacy_values
      ::V1::Legacy::CreditNoteSerializer.new(model).serialize
    end
  end
end
