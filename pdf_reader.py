# Et skript som tar inn en PDF og skriver ut en tekstfil med innholdet
# Husk å endre navn på PDF-en på linje 6.

# Vi åpner opp for å legge til ekstra kontekst via PDF-er
# https://balabala76.medium.com/gpt-4-turbo-with-your-own-pdf-documents-without-chunking-e3ad62936082
import PyPDF2
pdf_file = "2023-12-01 Styringsgruppemote DigiVe stland - Innkalling og sakspapir.pdf"

processed_text_list = []
# Åpne PDF i binær modus
with open(pdf_file, 'rb') as pdf_file:
    pdf_reader = PyPDF2.PdfReader(pdf_file)
    # Iterer gjennom tekst og legg til i liste
    for page_num in range(len(pdf_reader.pages)):
        page = pdf_reader.pages[page_num]
        page_text = page.extract_text()
        processed_text_list.append(page_text)

# Kombiner alt sammen til en streng
combined_text = " ".join(processed_text_list)
edit_combined_text = combined_text.replace(";","")
clean_pdf_text = edit_combined_text.replace("\n"," ")

# Her vi printer vi ut svarene vår til en CSV-fil
file1 = open("min_fil.csv", "w",encoding='utf-8', newline='') 
line = f'{clean_pdf_text}'
file1.write(line)
file1.close()

print("Nå er filen ferdig!")