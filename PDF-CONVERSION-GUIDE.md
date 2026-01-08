# 📄 PDF Conversion Guide for Sample Resume

This guide explains how to convert the `sample-resume-pdf.html` file to a professional PDF format.

## 🎯 Quick Methods

### Method 1: Browser Print-to-PDF (Recommended)

**Chrome/Edge:**
1. Open `sample-resume-pdf.html` in Chrome or Edge
2. Press `Ctrl+P` (Windows) or `Cmd+P` (Mac)
3. Select **"Save as PDF"** as the destination
4. Click **"More settings"**
5. Set:
   - Margins: **Minimum**
   - Scale: **100%**
   - Options: ✅ Background graphics
6. Click **"Save"**

**Firefox:**
1. Open `sample-resume-pdf.html` in Firefox
2. Press `Ctrl+P` (Windows) or `Cmd+P` (Mac)
3. Select **"Save to File"** → Choose **PDF** format
4. Set margins to **Minimum**
5. Enable **Background graphics**
6. Click **"Save"**

### Method 2: Online Conversion Tools

**Recommended Services:**
- [iLovePDF - HTML to PDF](https://www.ilovepdf.com/html-to-pdf)
- [HTML2PDF](https://html2pdf.com/)
- [PDF24](https://tools.pdf24.org/en/html-to-pdf)

**Steps:**
1. Upload `sample-resume-pdf.html` file
2. Configure settings (A4 size, margins)
3. Convert and download

### Method 3: Using Command Line Tools

**If you have Pandoc installed:**
```bash
pandoc sample-resume-pdf.html -o sample-resume.pdf --pdf-engine=wkhtmltopdf
```

**If you have wkhtmltopdf installed:**
```bash
wkhtmltopdf --page-size A4 --margin-top 15mm --margin-bottom 15mm --margin-left 15mm --margin-right 15mm sample-resume-pdf.html sample-resume.pdf
```

### Method 4: Using Node.js (markdown-pdf)

```bash
npm install -g markdown-pdf
# Note: This works better with markdown files
```

## ✅ PDF Quality Checklist

After conversion, verify:
- [ ] All text is readable and properly formatted
- [ ] Margins are appropriate (1.5cm recommended)
- [ ] Page breaks occur at logical points
- [ ] Colors and formatting are preserved
- [ ] File size is reasonable (< 2MB)
- [ ] All sections are complete and visible

## 📝 Customization Tips

### Before Converting:
1. **Edit the HTML file** to replace placeholder text:
   - Replace "YOUR FULL NAME" with actual name
   - Update contact information
   - Modify experience details
   - Update skills and certifications
   - Adjust education details

2. **Styling Adjustments:**
   - Modify colors in the `<style>` section
   - Adjust font sizes if needed
   - Change margins for different page sizes

3. **Content Updates:**
   - Add/remove experience items
   - Update skills list
   - Modify certifications section

## 🔧 Troubleshooting

**Problem: Text is cut off**
- Solution: Adjust margins or reduce font size

**Problem: Colors not showing**
- Solution: Enable "Background graphics" in print settings

**Problem: Page breaks in wrong places**
- Solution: Adjust CSS `page-break-inside: avoid` properties

**Problem: PDF file is too large**
- Solution: Compress using online PDF compressors

## 📚 Additional Resources

- [MDN: CSS Print Styles](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/print)
- [Can I Use: Print Media Queries](https://caniuse.com/css-mediaqueries)
- [PDF Optimization Guide](https://www.adobe.com/acrobat/resources/pdf-optimization.html)

## 💡 Pro Tips

1. **Always preview** before final conversion
2. **Test print** on actual paper to check formatting
3. **Keep both HTML and PDF** versions for easy updates
4. **Version control** your resume files
5. **Use consistent formatting** across all sections

---

**Need Help?** Open an issue in the repository or contact the maintainer.
