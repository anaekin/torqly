class Bookings::BookingPdf
  include ApplicationHelper

  def initialize(booking, template)
    @booking = booking
    @template = template
  end

  def render
    Prawn::Document.new do |pdf|
      PrawnHtml.append_html(pdf, @template)

      pdf.move_down 20
      pdf.text "Payments", size: 14, style: :bold
      pdf.move_down 8


      data = [ [ "ID", "Type", "Provider", "Amount", "Status", "Payment Ref" ] ]
      @booking.payments.each do |p|
        data << [
          "##{p.id}",
          p.payment_type,
          p.provider.presence || "-",
          eur(p.amount),
          p.status.titleize,
          p.payment_ref.presence || "-"
        ]
      end

      pdf.table(data, header: true, width: pdf.bounds.width) do
        row(0).background_color = "f5f5f5"
        row(0).font_style = :bold
        cells.size = 10
        cells.padding = 5
        cells.border_color = "dddddd"
      end
    end.render
  end
end
