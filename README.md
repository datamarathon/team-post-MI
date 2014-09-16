Shock Post MI
========

Comparison of pressors for treatment of myocardial-infarction-related
cardiogenic shock.

The SOAP II trial is the major RCT available comparing different
vasopressors. However, it combines all types of shock. Norepinephrine
looked better in the cardiogenic shock subgroup, but this also
combines all types of cardiogenic shock. We want to determine what is
the best pressor, *specifically* for myocardial-infarction-related
cardiogenic shock.

http://www.ncbi.nlm.nih.gov/pubmed/20200382

http://www.nejm.org/doi/full/10.1056/NEJMoa0907118

Methods
-------

MI defined as troponin-I or troponin-T > 1 mcg / L.

Cardiogenic shock defined as (cardiac output < 4 L / min AND wedge
pressure > 12 mmHg) OR ICD-9 code for cardiogenic shock OR hit on
"cardiogenic shock" free text in a clinical note.

![directed graph of queries](https://dl.dropboxusercontent.com/u/38640281/xfiles/postmi_graph.png)

Results
-------

Dopamine, n=118. In hospital mortaliy 46.6%

Norepinephrine n=44. In hospital mortaliy 68.2%

Both pressors ordered simultaneously, n=29. In hospital mortaliy 62.1%.

Fisher's exact P = 0.033.

![survival curves](https://dl.dropboxusercontent.com/u/38640281/xfiles/inhospital-mort.png)

Log-rank test for these curves, P = 0.004

Conclusions
----

Our results are unadjusted for any confounding by indication. Crude
results suggest the dopamine group has better survival. This is *in
contrast* to the SOAP II trial.

Team
----
* Ben Geisler
* Erina Ghosh
* Miriam Makhlouf
* Andrew Ward
* Andy Zimolzak

What is this I don't even
----

This is code written by our team during the second Critical Data
hackathon at MIT, September 5-7, 2014. We are querying the MIMIC II
Database. This is a publicly and freely available clinical database
that encompasses a large population of ICU patients and includes lab
results, electronic documentation, and bedside monitor trends and
waveforms.

https://mimic.physionet.org/

http://criticaldata.mit.edu/
