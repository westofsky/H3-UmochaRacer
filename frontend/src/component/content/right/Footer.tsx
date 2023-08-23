import React, {useContext} from 'react';
import styled from 'styled-components';
import {flexCenter} from '../../../style/common';
import {colors} from '../../../style/theme';
import {Body2_Medium, Title1_Medium} from '@/style/fonts';
import {OptionContext} from '@/provider/optionProvider';
import {TempOptionContext} from '@/provider/tempOptionProvider';
import {SelectedOptionContext} from '@/provider/selectedOptionProvider';

interface props {
  onClick: () => void;
  setIsSaved: React.Dispatch<React.SetStateAction<boolean>>;
  isOpen: boolean;
}
const upperButton = (isModalOpen: boolean) => {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width="16"
      height="16"
      viewBox="0 0 16 16"
      fill="none"
      style={{
        transform: isModalOpen ? 'rotate(-180deg)' : '',
        transition: '0.5s',
      }}
    >
      <path
        d="M7.99952 7.21865L4.69952 10.5186L3.75685 9.57598L7.99952 5.33331L12.2422 9.57598L11.2995 10.5186L7.99952 7.21865Z"
        fill="#AEB1B7"
      />
    </svg>
  );
};

const DEFAULT_PRICE = 43460000;
function Footer({onClick, isOpen, setIsSaved}: props) {
  const {option, setOption} = useContext(OptionContext);
  const {tempOption} = useContext(TempOptionContext);
  const {selectedOptions, addOption} = useContext(SelectedOptionContext);

  let totalPrice = DEFAULT_PRICE;
  let copyOption = selectedOptions.slice();

  if (tempOption !== null) {
    copyOption = copyOption.map((elem) => {
      if (elem.key === tempOption.key) {
        return tempOption;
      } else {
        return elem;
      }
    });
  }
  copyOption.map((elem) => {
    totalPrice += elem.price;
  });

  return (
    <Wrapper>
      <Total>
        <ModalToggle onClick={onClick}>
          총 견적금액
          <IconBox>{upperButton(isOpen)}</IconBox>
        </ModalToggle>
        <TotalPrice>{totalPrice.toLocaleString()} 원</TotalPrice>
      </Total>
      <OptionSwitcher>
        <PrevOptionButton onClick={() => setOption(option - 1)}>
          이전
        </PrevOptionButton>
        <NextOptionButton
          onClick={() => {
            setIsSaved(true);
            if (tempOption) addOption(tempOption);
            document.body.style.pointerEvents = 'none';
            setTimeout(() => {
              setOption(option + 1);
              document.body.style.pointerEvents = '';
            }, 2500);
          }}
        >
          선택 완료
        </NextOptionButton>
      </OptionSwitcher>
    </Wrapper>
  );
}

export default Footer;

const Wrapper = styled.div`
  display: flex;
  justify-content: space-between;
  position: absolute;
  bottom: 0;
  width: 100%;

  z-index: 3;
`;

const Total = styled.div`
  display: flex;
  flex-wrap: wrap;
  flex-direction: row;
  width: 135px;
  height: 100%;
  gap: 5px;
`;

const ModalToggle = styled.button`
  ${flexCenter}
  ${Body2_Medium};
  color: ${colors.Cool_Grey_003};
  gap: 5px;
`;

const TotalPrice = styled.div`
  ${Title1_Medium};
  text-wrap: nowrap;
`;

const OptionSwitcher = styled.div`
  display: flex;
  justify-content: space-between;
  width: 150px;
  height: 100%;
`;

const NextOptionButton = styled.button`
  ${flexCenter}
  ${Body2_Medium};
  width: 113px;
  padding: 14px 20px;
  border-radius: 6px;
  background: ${colors.Main_Hyundai_Blue};
  color: white;
  gap: 8px;
`;

const PrevOptionButton = styled.button`
  ${Body2_Medium};
  color: ${colors.Cool_Grey_003};
`;

const IconBox = styled.div`
  width: 16px;
  height: 16px;
  flex-shrink: 0;
  border-radius: 2px;
  background: var(--001, #f2f4f7);
`;