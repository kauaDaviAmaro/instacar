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
        origem: 'Shopping Iguatemi, São Paulo',
        destino: 'Aeroporto de Guarulhos',
        dataHora: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString(), // Tomorrow
        vagas: 3,
        status: 'disponível' as const,
        origem_lat: -23.5505,
        origem_lon: -46.6333,
        destino_lat: -23.4356,
        destino_lon: -46.4731,
        observacao: 'Saída pontual às 8h',
        vagasDisponiveis: 3
      },
      {
        motoristaId: users[1].id!,
        origem: 'Metrô Trianon-MASP, São Paulo',
        destino: 'Universidade de São Paulo - Butantã',
        dataHora: new Date(Date.now() + 2 * 24 * 60 * 60 * 1000).toISOString(), // Day after tomorrow
        vagas: 2,
        status: 'disponível' as const,
        origem_lat: -23.5613,
        origem_lon: -46.6565,
        destino_lat: -23.5613,
        destino_lon: -46.7305,
        observacao: 'Carro confortável, ar condicionado',
        vagasDisponiveis: 2
      },
      {
        motoristaId: users[2].id!,
        origem: 'Terminal Rodoviário Tietê',
        destino: 'Shopping Center Norte',
        dataHora: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000).toISOString(), // 3 days from now
        vagas: 1,
        status: 'disponível' as const,
        origem_lat: -23.5289,
        origem_lon: -46.6250,
        destino_lat: -23.5000,
        destino_lon: -46.6000,
        observacao: 'Moto, apenas 1 passageiro',
        vagasDisponiveis: 1
      },
      {
        motoristaId: users[3].id!,
        origem: 'Praça da República, São Paulo',
        destino: 'Parque Ibirapuera',
        dataHora: new Date(Date.now() + 4 * 24 * 60 * 60 * 1000).toISOString(), // 4 days from now
        vagas: 4,
        status: 'disponível' as const,
        origem_lat: -23.5451,
        origem_lon: -46.6333,
        destino_lat: -23.5873,
        destino_lon: -46.6575,
        observacao: 'Passeio no parque, retorno às 18h',
        vagasDisponiveis: 4
      },
      {
        motoristaId: users[4].id!,
        origem: 'Estação de Metrô Fradique Coutinho',
        destino: 'Hospital das Clínicas',
        dataHora: new Date(Date.now() + 5 * 24 * 60 * 60 * 1000).toISOString(), // 5 days from now
        vagas: 2,
        status: 'disponível' as const,
        origem_lat: -23.5613,
        origem_lon: -46.6565,
        destino_lat: -23.5613,
        destino_lon: -46.6565,
        observacao: 'Consulta médica, urgência',
        vagasDisponiveis: 2
      },
      {
        motoristaId: users[0].id!,
        origem: 'Aeroporto de Congonhas',
        destino: 'Centro de São Paulo',
        dataHora: new Date(Date.now() + 6 * 24 * 60 * 60 * 1000).toISOString(), // 6 days from now
        vagas: 3,
        status: 'disponível' as const,
        origem_lat: -23.6267,
        origem_lon: -46.6553,
        destino_lat: -23.5505,
        destino_lon: -46.6333,
        observacao: 'Chegada de voo, aguardar no desembarque',
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
