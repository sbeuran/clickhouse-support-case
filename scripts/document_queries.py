from prettytable import PrettyTable
import os
import subprocess
import sys

def run_query(query):
    """Run a query and return its results"""
    cmd = f"docker exec -i clickhouse-server clickhouse-client --format TSVWithNames --query \"{query}\""
    try:
        result = subprocess.check_output(cmd, shell=True).decode('utf-8')
        lines = result.strip().split('\n')
        if not lines:
            return [], []
        headers = lines[0].split('\t')
        rows = [line.split('\t') for line in lines[1:]]
        return headers, rows
    except subprocess.CalledProcessError:
        return [], []

def create_query_doc():
    """Create documentation for all queries"""
    with open('query_documentation.md', 'w') as doc:
        doc.write('# SQL Query Documentation\n\n')
        
        # Find all SQL files
        for root, _, files in os.walk('1-sql-queries'):
            sql_files = sorted([f for f in files if f.endswith('.sql')])
            if not sql_files:
                continue
                
            category = os.path.basename(root)
            doc.write(f'## {category.upper()}\n\n')
            
            for sql_file in sql_files:
                file_path = os.path.join(root, sql_file)
                
                # Read query
                with open(file_path, 'r') as f:
                    query_content = f.read()
                
                # Extract description
                description = [line for line in query_content.split('\n') if '-- Description:' in line]
                description = description[0].replace('-- Description:', '').strip() if description else ''
                
                # Document query
                doc.write(f'### {sql_file}\n')
                doc.write(f'**Description:** {description}\n\n')
                doc.write('**Query:**\n```sql\n')
                doc.write(query_content)
                doc.write('\n```\n\n')
                
                # Run query and format results
                query = query_content.split(';')[0]  # Get first query
                headers, rows = run_query(query)
                
                if headers and rows:
                    doc.write('**Results:**\n\n')
                    table = PrettyTable()
                    table.field_names = headers
                    for row in rows:
                        table.add_row(row)
                    doc.write('```\n')
                    doc.write(str(table))
                    doc.write('\n```\n\n')
                else:
                    doc.write('**No results or query failed**\n\n')
                
                doc.write('---\n\n')

if __name__ == '__main__':
    create_query_doc()
