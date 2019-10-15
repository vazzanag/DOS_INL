using iText.Kernel.Events;
using iText.Kernel.Geom;
using iText.Kernel.Pdf;
using iText.Kernel.Pdf.Canvas;
using iText.Kernel.Pdf.Xobject;
using iText.Layout;
using iText.Layout.Element;
using iText.Layout.Properties;
using System;
using System.Collections.Generic;
using System.Text;
namespace INL.Services.Utilities
{
    public class HeaderHandler : IEventHandler
    {
        protected PdfFormXObject placeholder;
        protected float side = 20;
        protected float x = 560;
        protected float y = 760;
        protected float space = 4.5f;
        protected float descent = 5;
        public string AdditionalText { get; set; }

        public HeaderHandler(PdfDocument pdf)
        {
            placeholder = new PdfFormXObject(new Rectangle(0, 0, side, side));
        }

        public void HandleEvent(Event e)
        {
            PdfDocumentEvent docEvent = (PdfDocumentEvent)e;
            PdfDocument pdf = docEvent.GetDocument();
            PdfPage page = docEvent.GetPage();
            int pageNumber = docEvent.GetDocument().GetPageNumber(page);
            Rectangle pageSize = page.GetPageSize();
            PdfCanvas pdfCanvas = new PdfCanvas(page.GetLastContentStream(), page.GetResources(), pdf);
            Canvas canvas = new Canvas(pdfCanvas, pdf, pageSize);
            Paragraph p = new Paragraph().Add(AdditionalText);
            canvas.ShowTextAligned(p, x, y, TextAlignment.RIGHT);
            pdfCanvas.AddXObject(placeholder, x + space, y - descent);

            pdfCanvas.Release();
        }
    }
}