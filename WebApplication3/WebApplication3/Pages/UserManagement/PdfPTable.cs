using System;

namespace WebApplication3.Pages.UserManagement
{
    internal class PdfPTable
    {
        private int v;

        public PdfPTable(int v)
        {
            this.v = v;
        }

        public object DefaultCell { get; internal set; }
        public int TotalWidth { get; internal set; }

        internal void AddCell(Phrase phrase)
        {
            throw new NotImplementedException();
        }

        internal void WriteSelectedRows(int v1, int v2, int leftMargin, object p, object directContent)
        {
            throw new NotImplementedException();
        }
    }
}