import fs from 'fs';
import path from 'path';
import sqlite3 from 'sqlite3';

const dbPath = path.join(__dirname, '../database.sqlite');

// Função para executar uma migration SQL
function runMigration(sqlFile: string): Promise<void> {
    return new Promise((resolve, reject) => {
        const db = new sqlite3.Database(dbPath);
        
        fs.readFile(sqlFile, 'utf8', (err, data) => {
            if (err) {
                reject(err);
                return;
            }
            
            // Dividir o SQL em statements individuais
            const statements = data.split(';').filter(stmt => stmt.trim().length > 0);
            
            let completed = 0;
            let hasError = false;
            
            statements.forEach((statement, index) => {
                if (hasError) return;
                
                const trimmedStatement = statement.trim();
                if (trimmedStatement.length === 0) {
                    completed++;
                    if (completed === statements.length) {
                        console.log(`Migration ${path.basename(sqlFile)} executada com sucesso`);
                        db.close();
                        resolve();
                    }
                    return;
                }
                
                db.run(trimmedStatement, (err) => {
                    if (err) {
                        console.error(`Erro na statement ${index + 1}:`, err);
                        console.error('Statement:', trimmedStatement);
                        hasError = true;
                        db.close();
                        reject(err);
                        return;
                    }
                    
                    completed++;
                    if (completed === statements.length) {
                        console.log(`Migration ${path.basename(sqlFile)} executada com sucesso`);
                        db.close();
                        resolve();
                    }
                });
            });
        });
    });
}

// Executar todas as migrations
async function runMigrations() {
    const migrationsDir = path.join(__dirname, '../migrations');
    
    try {
        const files = fs.readdirSync(migrationsDir)
            .filter(file => file.endsWith('.sql'))
            .sort();
        
        console.log('Executando migrations...');
        
        for (const file of files) {
            const migrationPath = path.join(migrationsDir, file);
            await runMigration(migrationPath);
        }
        
        console.log('Todas as migrations foram executadas com sucesso!');
    } catch (error) {
        console.error('Erro ao executar migrations:', error);
        process.exit(1);
    }
}

// Executar se chamado diretamente
if (require.main === module) {
    runMigrations();
}

export { runMigrations };
