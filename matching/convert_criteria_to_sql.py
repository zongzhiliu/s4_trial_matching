"""convert the trial-criteria matrix to sql files

aiming at disease=nsclc only
"""
import warnings


def quote(x):
    return f"'{x}'"

class CriterionConverter():
    config = dict(
        histology={'small cell carcinoma', 'squamou cell carcinoma', 'carcinoid'}
        )

    def convert_histology(self, cond):
        """make a list of included histologies

        eg: squamous cell carcinoma -> in ('squamous cell carcinoma')
        eg: not(small cell carcinoma) -> not in ('small cell carcinoma', 'carcinoid')
            later EXCLUDING: [x for x in accepted_disease_histologies if x not in (...)]
        """
        valids = self.config['histology']
        if cond.startswith('not'):
            heading = 'NOT IN'
            items_raw = cond[3:].strip(':()')
        else:
            heading = 'IN'
            items_raw = cond.strip('()')

        items = [x.strip() for x in items_raw.split(',')]
        for x in items:
            if not x in valids:
                warnings.warn(f'{x} not in valids: {valids}')

        items_str = ', '.join(quote(x) for x in items)
        return f"""{heading} ({items_str})"""

