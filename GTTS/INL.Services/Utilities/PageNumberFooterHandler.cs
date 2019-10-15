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
    public class PageNumberFooterHandler : IEventHandler
    {
        protected PdfFormXObject placeholder;
        protected float side = 20;
        protected float x = 550;
        protected float y = 25;
        protected float space = 4.5f;
        protected float descent = 3;

        public PageNumberFooterHandler(PdfDocument pdf)
        {
            placeholder = new PdfFormXObject(new Rectangle(0, 0, side, side));
        }

        public void HandleEvent(Event e) {
            PdfDocumentEvent docEvent = (PdfDocumentEvent) e;
            PdfDocument pdf = docEvent.GetDocument();
            PdfPage page = docEvent.GetPage();
            int pageNumber = docEvent.GetDocument().GetPageNumber(page);
            Rectangle pageSize = page.GetPageSize();
            PdfCanvas pdfCanvas = new PdfCanvas(page.GetLastContentStream(), page.GetResources(), pdf);
            Canvas canvas = new Canvas(pdfCanvas, pdf, pageSize);
            Paragraph p1 = new Paragraph().Add("Page ").Add(pageNumber.ToString()).Add(" of");
            canvas.ShowTextAligned(p1, x, y, TextAlignment.RIGHT);
            pdfCanvas.AddXObject(placeholder, x + space, y - descent);

            pdfCanvas.Release();
        }

        public void writeTotal(PdfDocument pdf)
        {
            Canvas canvas = new Canvas(placeholder, pdf);
            canvas.ShowTextAligned(pdf.GetNumberOfPages().ToString(), 0, descent, TextAlignment.LEFT);
        }
        
    }
}
