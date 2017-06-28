using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace TextProcessing
{
    public partial class Form1 : Form
    {
        // transition words (the, and, an etc)
        private string transitionFileText;
        private string textToProcess;

        public Form1()
        {
            InitializeComponent();
            // Transition and Process buttons disabled on load to stop the user jumping straight to process without anything else loaded
            DisableAndClearForm();
        }

        #region Buttons
        
        private void btnFindFile_Click(object sender, EventArgs e)
        {
            try
            {
                OpenTextFile();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void btnTransition_Click(object sender, EventArgs e)
        {
            try
            {
                OpenTransitionWordsTextFile();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void btnProcess_Click(object sender, EventArgs e)
        {
            try
            {
                ProcessTextFile(textToProcess);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        #endregion

        #region Open File Methods

        // Opens the file dialog to find a text file to process
        private void OpenTextFile()
        {
            // Create a file dialog object and assign its title, type of file and starting directory
            OpenFileDialog fileDialog = new OpenFileDialog();
            fileDialog.Title = "Open Text File";
            fileDialog.Filter = "TXT files|*.txt";
            fileDialog.InitialDirectory = @"C:\";

            if (fileDialog.ShowDialog() == DialogResult.OK)
            {
                string fileName = fileDialog.FileName;
                txtFilePath.Text = fileName;
                textToProcess = File.ReadAllText(fileName);
                btnTransition.Enabled = true;
            }
        }

        private void OpenTransitionWordsTextFile()
        {
            // Create a file dialog object and assign its title, type of file and starting directory
            OpenFileDialog fileDialog = new OpenFileDialog();
            fileDialog.Title = "Open Transition Words Text File";
            fileDialog.Filter = "TXT files|*.txt";
            fileDialog.InitialDirectory = @"C:\";

            if (fileDialog.ShowDialog() == DialogResult.OK)
            {
                string fileName = fileDialog.FileName;
                txtTransitionWords.Text = fileName;
                transitionFileText = File.ReadAllText(fileName);
                btnProcess.Enabled = true;
            }
        }

        #endregion

        #region Processing Methods

        // Processes the contents of the text file
        private void ProcessTextFile(string pFileText)
        {
            // convert the transition words string to a list
            List<string> transitionWordList = transitionFileText.Split(',').ToList();
            // create a list of punctuation and character delimiters
            char[] delimiters = {' ', ',', '.', ':', '\t', '\r', '\n', '?', '-', ';', '!', '\"'};
            // split the input string into an array of words
            string[] fileWordArray = pFileText.Split(delimiters);
            // copy array to a list as there are more ways to manipulate it
            List<string> fileWords = new List<string>(fileWordArray);
            // WordsList that will the filtered list of words but created here for scope purposes
            List<string> fileWordsList = new List<string>();
            // Dictionary to hold the words and the amount of times it is mentioned
            Dictionary<string, int> fileWordDictionary = new Dictionary<string, int>();

            // iterate over the array of words removing link words and blank items
            foreach (string word in fileWords)
            {
                // make each word lower case
                var comparedWord = word.ToLower();

                if(!transitionWordList.Contains(comparedWord))
                {
                    fileWordsList.Add(comparedWord);
                }
            }

            foreach (string word in fileWordsList)
            {
                // check if dictionary.contains word - if it does increment - else add it
                if (fileWordDictionary.Keys.Contains(word))
                {
                    // increment the value associated with the word in the dictionary
                    fileWordDictionary[word]++;
                }
                else
                {
                    // add the word to the dictionary along with a count of 1
                    fileWordDictionary.Add(word, 1);
                }
            }

            // Sort the dictionary by the value
            var sortedWordDictionary = from pair in fileWordDictionary
                                       orderby pair.Value descending
                                       select pair;
            
            // Call the display method
            DisplayResults(sortedWordDictionary);
        }

        // Displays the top 10 words and their counts
        private void DisplayResults(IEnumerable<KeyValuePair<string, int>> pSortedWordDictionary)
        {
            StringBuilder sb = new StringBuilder();

            // iterate over the first 10 items in the sortedDictionary object
            foreach (var pair in pSortedWordDictionary.Take(10))
            {
                // add the key/value pair to the stringbuilder
                sb.AppendFormat("{0} - {1}{2}", pair.Key, pair.Value, Environment.NewLine);
            }

            // assign the stringbuilder object to a normal string ready for displaying
            string result = sb.ToString();
            // display the result in the richtextbox
            rtDisplayArea.Text = result;

            DisableAndClearForm();
        }

        #endregion

        #region Clear

        // Clears the text boxes and disables the buttons to enable user to start again
        private void DisableAndClearForm()
        {
            btnTransition.Enabled = false;
            btnProcess.Enabled = false;
            txtFilePath.Text = "";
            txtTransitionWords.Text = "";
        }

        #endregion
    }
}
