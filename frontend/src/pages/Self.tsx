import React from 'react';
import styled from 'styled-components';
import Header from '../component/header/Header';
import Progress from '../component/progress/Progress';
import Content from '@/component/content/Content';
import content from '@/assets/mocks/powertrain.json';

function Self() {
  return (
    <Wrapper>
      <Header />
      <Progress />
      <Content ContentData={content.data} />
    </Wrapper>
  );
}

export default Self;
const Wrapper = styled.div`
  width: 100vw;
  height: 100vh;
  display: flex;
  flex-direction: column;
`;
