import Carona from '../models/carona';
import User from '../models/User';

export const seedCaronas = async () => {
  try {
    console.log('🌱 Seeding caronas...');
    
    // Check if caronas already exist
    const existingCaronas = await Carona.count();
    if (existingCaronas > 0) {
      console.log('✅ Caronas already exist, skipping carona seeding');
      return;
    }

    // Get user IDs for creating caronas
    const users = await User.findAll();
    if (users.length === 0) {
      console.log('⚠️ No users found, skipping carona seeding');
      return;
    }

    const caronas = [
      {
        motoristaId: users[0].id!,
        origem: 'Centro, Marília',
        destino: 'Rodoviária, Marília',
        dataHora: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString(), // Amanhã
        vagas: 3,
        status: 'disponível' as const,
        origem_lat: -22.2171,
        origem_lon: -49.9501,
        destino_lat: -22.2039,
        destino_lon: -49.9415,
        observacao: 'Saída pontual às 8h',
        vagasDisponiveis: 3
      },
      {
        motoristaId: users[1].id!,
        origem: 'Cascata, Marília',
        destino: 'UNIMAR, Marília',
        dataHora: new Date(Date.now() + 2 * 24 * 60 * 60 * 1000).toISOString(), // Depois de amanhã
        vagas: 2,
        status: 'disponível' as const,
        origem_lat: -22.2260,
        origem_lon: -49.9850,
        destino_lat: -22.2109,
        destino_lon: -49.9548,
        observacao: 'Carro confortável, ar condicionado',
        vagasDisponiveis: 2
      },
      {
        motoristaId: users[2].id!,
        origem: 'Palmital, Marília',
        destino: 'Centro, Marília',
        dataHora: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000).toISOString(), // +3 dias
        vagas: 1,
        status: 'disponível' as const,
        origem_lat: -22.2100,
        origem_lon: -49.9600,
        destino_lat: -22.2171,
        destino_lon: -49.9501,
        observacao: 'Moto, apenas 1 passageiro',
        vagasDisponiveis: 1
      },
      {
        motoristaId: users[3].id!,
        origem: 'Nova Marília, Marília',
        destino: 'Marília Shopping',
        dataHora: new Date(Date.now() + 4 * 24 * 60 * 60 * 1000).toISOString(), // +4 dias
        vagas: 4,
        status: 'disponível' as const,
        origem_lat: -22.2250,
        origem_lon: -49.9400,
        destino_lat: -22.2106,
        destino_lon: -49.9514,
        observacao: 'Passeio no shopping, retorno às 18h',
        vagasDisponiveis: 4
      },
      {
        motoristaId: users[4].id!,
        origem: 'Lácio, Marília',
        destino: 'Centro, Marília',
        dataHora: new Date(Date.now() + 5 * 24 * 60 * 60 * 1000).toISOString(), // +5 dias
        vagas: 2,
        status: 'disponível' as const,
        origem_lat: -22.2300,
        origem_lon: -49.9520,
        destino_lat: -22.2171,
        destino_lon: -49.9501,
        observacao: 'Saída após o expediente',
        vagasDisponiveis: 2
      },
      {
        motoristaId: users[0].id!,
        origem: 'Marília Shopping',
        destino: 'Centro, Marília',
        dataHora: new Date(Date.now() + 6 * 24 * 60 * 60 * 1000).toISOString(), // +6 dias
        vagas: 3,
        status: 'disponível' as const,
        origem_lat: -22.2106,
        origem_lon: -49.9514,
        destino_lat: -22.2171,
        destino_lon: -49.9501,
        observacao: 'Retorno do shopping',
        vagasDisponiveis: 3
      }
    ];

    await Carona.bulkCreate(caronas);
    console.log('✅ Caronas seeded successfully!');
  } catch (error) {
    console.error('❌ Error seeding caronas:', error);
    throw error;
  }
};
