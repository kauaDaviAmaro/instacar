import bcrypt from 'bcryptjs';
import User from '../models/User';

export const seedUsers = async () => {
  try {
    console.log('🌱 Seeding users...');
    
    // Check if users already exist
    const existingUsers = await User.count();
    if (existingUsers > 0) {
      console.log('✅ Users already exist, skipping user seeding');
      return;
    }

    const users = [
      {
        name: 'João Silva',
        email: 'joao@example.com',
        password: await bcrypt.hash('123456', 10),
        birthDate: '1990-05-15',
        phone: '(11) 99999-9999',
        cep: '01234-567',
        number: '123',
        gender: 'Masculino',
        tipoVeiculo: 'Carro',
        modeloVeiculo: 'Honda Civic',
        corVeiculo: 'Prata',
        placa: 'ABC-1234',
        fotoPerfil: 'https://via.placeholder.com/150/0000FF/808080?text=João'
      },
      {
        name: 'Maria Santos',
        email: 'maria@example.com',
        password: await bcrypt.hash('123456', 10),
        birthDate: '1992-08-22',
        phone: '(11) 88888-8888',
        cep: '04567-890',
        number: '456',
        gender: 'Feminino',
        tipoVeiculo: 'Carro',
        modeloVeiculo: 'Toyota Corolla',
        corVeiculo: 'Branco',
        placa: 'DEF-5678',
        fotoPerfil: 'https://via.placeholder.com/150/FF0000/808080?text=Maria'
      },
      {
        name: 'Pedro Oliveira',
        email: 'pedro@example.com',
        password: await bcrypt.hash('123456', 10),
        birthDate: '1988-12-10',
        phone: '(11) 77777-7777',
        cep: '07890-123',
        number: '789',
        gender: 'Masculino',
        tipoVeiculo: 'Moto',
        modeloVeiculo: 'Honda CB 600',
        corVeiculo: 'Vermelho',
        placa: 'GHI-9012',
        fotoPerfil: 'https://via.placeholder.com/150/00FF00/808080?text=Pedro'
      },
      {
        name: 'Ana Costa',
        email: 'ana@example.com',
        password: await bcrypt.hash('123456', 10),
        birthDate: '1995-03-18',
        phone: '(11) 66666-6666',
        cep: '02345-678',
        number: '321',
        gender: 'Feminino',
        tipoVeiculo: 'Carro',
        modeloVeiculo: 'Volkswagen Gol',
        corVeiculo: 'Azul',
        placa: 'JKL-3456',
        fotoPerfil: 'https://via.placeholder.com/150/FFFF00/808080?text=Ana'
      },
      {
        name: 'Carlos Ferreira',
        email: 'carlos@example.com',
        password: await bcrypt.hash('123456', 10),
        birthDate: '1991-07-25',
        phone: '(11) 55555-5555',
        cep: '05678-901',
        number: '654',
        gender: 'Masculino',
        tipoVeiculo: 'Carro',
        modeloVeiculo: 'Ford Focus',
        corVeiculo: 'Preto',
        placa: 'MNO-7890',
        fotoPerfil: 'https://via.placeholder.com/150/FF00FF/808080?text=Carlos'
      }
    ];

    await User.bulkCreate(users);
    console.log('✅ Users seeded successfully!');
  } catch (error) {
    console.error('❌ Error seeding users:', error);
    throw error;
  }
};
